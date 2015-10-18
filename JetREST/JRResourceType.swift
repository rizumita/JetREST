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
    
}

public protocol JRGet: JRResourceType {
    
    typealias GetSerializerType: JRSerializerType

    static var getSerializer: GetSerializerType { get }

    static func get(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequest<GetSerializerType>
    
    static func get(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequest<GetSerializerType>

    static func get(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequest<GetSerializerType>

}

extension JRGet {

    static func get(parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequest<GetSerializerType> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return JRRequest(method: .GET, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers, serializer: getSerializer)
    }

    static func get(object object: Any, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequest<GetSerializerType> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return JRRequest(method: .GET, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(object: object)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers, serializer: getSerializer)
    }

    static func get(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequest<GetSerializerType> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return JRRequest(method: .GET, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(dictionary: dictionary)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers, serializer: getSerializer)
    }

}

public protocol JRPost: JRResourceType {
    
    typealias PostSerializerType: JRSerializerType
    
    static var postSerializer: PostSerializerType { get }

    static func post(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequest<PostSerializerType>

    static func post(object object: Any, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequest<PostSerializerType>

    static func post(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRRequest<PostSerializerType>

}

extension JRPost {

    static func post(parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequest<PostSerializerType> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return JRRequest(method: .POST, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers, serializer: postSerializer)
    }

    static func post(object object: Any, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequest<PostSerializerType> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }

        return JRRequest(method: .POST, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(object: object)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers, serializer: postSerializer)
    }
    
    static func post(dictionary dictionary: [String : AnyObject], parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRRequest<PostSerializerType> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return JRRequest(method: .POST, URL: baseURL.URLByAppendingPathComponent(try path.expandPath(dictionary: dictionary)), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers, serializer: postSerializer)
    }

}

public protocol JRPaginate: JRResourceType {
    
    typealias PageSerializerType: JRPageSerializerType
    
    static var pageSerializer: PageSerializerType { get }

    static func paginate(parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?) throws -> JRPaginator<JRPageRequest<PageSerializerType>>
    
}

extension JRPaginate {
    
    static func paginate(parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) throws -> JRPaginator<JRPageRequest<PageSerializerType>> {
        guard let baseURL = ServiceType.baseURL else {
            throw JetRESTError.BaseURLError
        }
        
        return JRPaginator(request: JRPageRequest(method: .GET, URL: baseURL.URLByAppendingPathComponent(path.rawPath), parameters: parameters, parameterEncoding: parameterEncoding, headers: headers, serializer: pageSerializer))
    }
    
}
