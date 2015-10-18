//
//  JRResourceType.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/26.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public protocol JRResourceType {

    typealias ServiceType: JRServiceType

    static var path: JRPathType { get }
    
    static func request(method method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) -> JRRequestType
    
}

public extension JRResourceType {
    
    static func request(method method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) -> JRRequestType {
        return JRRequest(method: method, URL: URL, parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }
    
}

public protocol JRGet: JRResourceType {
    
    static func get(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType
    
    static func get(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType

    static func get(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType

}

extension JRGet {

    static func get(parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .GET, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

    static func get(object object: Any, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .GET, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(object: object)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

    static func get(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .GET, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(dictionary: dictionary)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

}

public protocol JRPost: JRResourceType {

    static func post(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType

    static func post(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType

    static func post(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType

}

extension JRPost {

    static func post(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .POST, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

    static func post(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .POST, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(object: object)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }
    
    static func post(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequestType {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return request(method: .POST, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(dictionary: dictionary)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers)
    }

}

public protocol JRPaginate: JRResourceType {
    
    typealias PageSerializerType: JRPageSerializerType
    
    static var pageSerializer: PageSerializerType { get }

    static func paginate(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRPaginator<PageSerializerType>
    
}

extension JRPaginate {
    
    static func paginate(parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRPaginator<PageSerializerType> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return JRPaginator(request: request(method: .GET, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers) as! JRRequest, serializer: pageSerializer)
    }
    
}
