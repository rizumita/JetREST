//
//  Fixture.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/27.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import OHHTTPStubs
import Alamofire

let usersGetFixture = Fixture(filename: "users.json", URL: NSURL(string: "https://example.com/api/users")!)
let userGetFixture: Int -> Fixture = { Fixture(filename: "user.json", URL: NSURL(string: "https://example.com/api/user/\($0)")!, replaced: ["@id" : "\($0)"]) }

func fix(fixture: Fixture) {
    OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
        return fixture.URL == request.URL && request.HTTPMethod == fixture.method.rawValue
        }) { (request: NSURLRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data: fixture.replacedJSONString.dataUsingEncoding(NSUTF8StringEncoding)!, statusCode: fixture.statusCode, headers: fixture.headers)
    }
}

class Fixture {
    
    let method: Alamofire.Method
    let path: String
    let URL: NSURL
    let statusCode: Int32
    let headers: [NSObject : AnyObject]?
    let replaced: [String : String]
    
    var replacedJSONString: String {
        var string = try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)

        for (before, after) in replaced {
            string = string.stringByReplacingOccurrencesOfString(before, withString: after)
        }
        
        return string as String
    }
    
    init(filename: String, URL: NSURL, method: Alamofire.Method = .GET, statusCode: Int32 = 200, headers: [NSObject : AnyObject]? = nil, replaced: [String : String] = [:]) {
        self.path = OHPathForFile(filename, self.dynamicType)!
        self.URL = URL
        self.method = method
        self.statusCode = statusCode
        self.headers = headers
        self.replaced = replaced
    }

}