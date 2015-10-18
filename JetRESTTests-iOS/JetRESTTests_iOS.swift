//
//  JetRESTTests_iOS.swift
//  JetRESTTests-iOS
//
//  Created by 和泉田領一 on 2015/09/26.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import JetREST
import Himotoki
import Alamofire

protocol TestResourceType: JRResourceType {
    typealias ServiceType = TestService
}

struct TestService: JRServiceType {
    static let baseURL: NSURL? = NSURL(string: "https://example.com/api")
    
    struct UsersResource: TestResourceType, JRPaginate {
        static let path: JRPathType = "/users"
        static var pageSerializer = JSONPageSerializer(contentsDecoder: JSONDecoder(keyPath: "users") { try decodeArray($0) as [User] }, paginationDecoder: JSONPaginationDecoder(keyPath: "pagination") { try decode($0) as Pagination })
    }
    
    struct UserResource: TestResourceType, JRGet, JRPost {
        static let getSerializer = JSONSerializer(contentsDecoder: JSONDecoder { try decode($0) as User })
        static let postSerializer = JSONSerializer(contentsDecoder: JSONDecoder { try decode($0) as User })
        static let path: JRPathType = "/user/:id"
    }
}

class JetRESTTests_iOS: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        
        super.tearDown()
    }
    
    func testGetUsers() {
        fix(usersGetFixture)
        
        let expectation = expectationWithDescription("get users")
        
        try! TestService.UsersResource.paginate().loadNextPage { (result: Result<([User], Pagination), JetRESTError>) -> Void in
            switch result {
            case .Success(let users, let pagination):
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first!.id, 123)
                XCTAssertEqual(users.first!.name, "rizumita")
                XCTAssertEqual(users.first!.sex, Sex.Male)
                XCTAssertEqual(pagination.total, 14)
                XCTAssertEqual(pagination.totalPages, 1)
                XCTAssertEqual(pagination.offset, 0)
                expectation.fulfill()
            case .Failure(let e):
                print(e)
                XCTFail()
            }
        }
        
        waitForExpectationsWithTimeout(3.0, handler: nil)
    }
    
    func testGetUser() {
        let id = 100
        fix(userGetFixture(id))
        
        let expectation = expectationWithDescription("get user")
        
        try! TestService.UserResource.get(dictionary: ["id" : id]).execute { response in
            switch response.result {
            case .Success(let object):
                XCTAssertEqual(object.id, id)
                XCTAssertEqual(object.name, "rizumita")
                XCTAssertEqual(object.sex, Sex.Male)
            case .Failure(let e):
                print(e)
                XCTFail()
            }
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(3.0, handler: nil)
    }
    
    func testPostUser() {
        let id = 100
        fix(userPostFixture(id))
        
        let expectation = expectationWithDescription("post user")
        
        let user = User(id: id, name: "ryoichi", sex: .Male)
        
        try! TestService.UserResource.post(object: user).execute { response in
            switch response.result {
            case .Success(let object):
                XCTAssert(object.id == 100)
                XCTAssert(object.name == "ryoichi")
                XCTAssert(object.sex == .Male)
                expectation.fulfill()
            case .Failure(let e):
                print(e)
                XCTFail()
            }
        }
        
        waitForExpectationsWithTimeout(3.0, handler: nil)
    }
    
}
