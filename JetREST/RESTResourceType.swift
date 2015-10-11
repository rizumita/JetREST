//
//  RESTResourceType.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/26.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public protocol RESTResourceType {

    typealias ServiceType: RESTServiceType
    
    static var path: RESTPathType { get }
    
    static func request(method method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) -> RESTRequestType
    
}

public extension RESTResourceType {
    
    static func request(method method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) -> RESTRequestType {
        return RESTRequest(method: method, URL: URL, parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }
    
}

public protocol RESTGet {
    
    static func get(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType
    
    static func get(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType

    static func get(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType

}

extension RESTGet where Self: RESTResourceType {

    static func get(parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> RESTRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .GET, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

    static func get(object object: Any, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> RESTRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .GET, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(object: object)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

    static func get(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> RESTRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .GET, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(dictionary: dictionary)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

}

public protocol RESTPost {

    static func post(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType

    static func post(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType

    static func post(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType

}

extension RESTPost where Self: RESTResourceType {

    static func post(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .POST, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

    static func post(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .POST, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(object: object)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }
    
    static func post(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> RESTRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .POST, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(dictionary: dictionary)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

}
