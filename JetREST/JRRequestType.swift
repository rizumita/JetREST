//
//  JRRequestType.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/26.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public protocol JRRequestType {
    
    typealias SerializerType: JRSerializerType
    
    var method: Alamofire.Method { get }
    
    var URL: URLStringConvertible { get }
    
    var parameters: [String : AnyObject]? { get }
    
    var parameterEncoding: ParameterEncoding { get }
    
    var headers: [String : String]? { get }
    
    var serializer: SerializerType { get }

    func execute(queue queue: dispatch_queue_t, completion: (Response<SerializerType.SerializedObject, SerializerType.ErrorObject> -> Void))
    
    init(method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?, serializer: SerializerType)

}

extension JRRequestType {

    public func execute(queue queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), completion: (Response<SerializerType.SerializedObject, SerializerType.ErrorObject> -> Void) = {_ in}) {
        Alamofire.request(method, URL, parameters: parameters, encoding: parameterEncoding, headers: headers).response(queue: queue, responseSerializer: serializer, completionHandler: completion)
    }

}

public protocol JRPageRequestType: JRRequestType {
    
    typealias SerializerType: JRPageSerializerType
    
}

public struct JRRequest<S: JRSerializerType>: JRRequestType {
    
    public typealias SerializerType = S
    
    public let method: Alamofire.Method
    
    public let URL: URLStringConvertible
    
    public let parameters: [String : AnyObject]?
    
    public let parameterEncoding: ParameterEncoding
    
    public let headers: [String : String]?
    
    public let serializer: SerializerType

    public init(method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil, serializer: SerializerType) {
        self.method = method
        self.URL = URL
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.headers = headers
        self.serializer = serializer
    }

}

public struct JRPageRequest<S: JRPageSerializerType>: JRPageRequestType {
    
    public typealias SerializerType = S
    
    public let method: Alamofire.Method
    
    public let URL: URLStringConvertible
    
    public let parameters: [String : AnyObject]?
    
    public let parameterEncoding: ParameterEncoding
    
    public let headers: [String : String]?
    
    public let serializer: SerializerType
    
    public init(method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil, serializer: SerializerType) {
        self.method = method
        self.URL = URL
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.headers = headers
        self.serializer = serializer
    }

}
