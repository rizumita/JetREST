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

protocol TestResourceType: RESTResourceType {
    typealias ServiceType = TestService
}

struct TestService: RESTServiceType {
    static let baseURL: NSURL? = NSURL(string: "https://example.com/api")

    struct UsersResource: TestResourceType, RESTGet {
        static let path: RESTPathType = "/users"
    }
    
    struct UserResource: TestResourceType, RESTGet, RESTPost {
        static let path: RESTPathType = "/user/:id"
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

        try! TestService.UsersResource.get().execute(serializer: JSONSerializer<[User]>(decoder: { try decodeArray($0) as [User] })) { response in
            switch response.result {
            case .Success(let users):
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first!.id, 123)
                XCTAssertEqual(users.first!.name, "rizumita")
                XCTAssertEqual(users.first!.sex, Sex.Male)
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
        
        try! TestService.UserResource.get(dictionary: ["id" : id]).execute(serializer: JSONSerializer(decoder: { try decode($0) as User })) { response in
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
    
}
