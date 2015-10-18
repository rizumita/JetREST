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
    
    var method: Alamofire.Method { get }
    
    var URL: URLStringConvertible { get }
    
    var parameters: [String : AnyObject]? { get }
    
    var parameterEncoding: ParameterEncoding { get }
    
    var headers: [String : String]? { get }

    func execute<T: ResponseSerializerType>(serializer serializer: T, queue: dispatch_queue_t, completion: (Response<T.SerializedObject, T.ErrorObject> -> Void))
    
    init(method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]?, parameterEncoding: ParameterEncoding, headers: [String : String]?)

}

extension JRRequestType {

    public var rawRequest: Alamofire.Request {
        return Alamofire.request(method, URL, parameters: parameters, encoding: parameterEncoding, headers: headers)
    }
    
    public func execute<T: ResponseSerializerType>(serializer serializer: T, queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), completion: (Response<T.SerializedObject, T.ErrorObject> -> Void) = {_ in}) {
        Alamofire.request(method, URL, parameters: parameters, encoding: parameterEncoding, headers: headers).response(queue: queue, responseSerializer: serializer, completionHandler: completion)
    }

}

public struct JRRequest: JRRequestType {
    
    public let method: Alamofire.Method
    
    public let URL: URLStringConvertible
    
    public let parameters: [String : AnyObject]?
    
    public let parameterEncoding: ParameterEncoding
    
    public let headers: [String : String]?

    public init(method: Alamofire.Method, URL: URLStringConvertible, parameters: [String : AnyObject]? = nil, parameterEncoding: ParameterEncoding = .URL, headers: [String : String]? = nil) {
        self.method = method
        self.URL = URL
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.headers = headers
    }

}

public struct DataSerializer: ResponseSerializerType {
    
    public typealias SerializedObject = NSData
    
    public typealias ErrorObject = JetRESTError
    
    public var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<SerializedObject, ErrorObject> = { _, _, data, error in
        if let data = data {
            return Result.Success(data)
        } else {
            return Result.Failure(JetRESTError.ResponseError(underlyngError: error))
        }
    }
    
}

public struct JSONSerializer<T>: ResponseSerializerType {
    
    public typealias SerializedObject = T
    
    public typealias ErrorObject = JetRESTError
    
    public var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<SerializedObject, ErrorObject>
    
    init(decoder: (AnyObject throws -> T), options: NSJSONReadingOptions = .AllowFragments) {
        self.serializeResponse = { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Result<SerializedObject, ErrorObject> in
            guard let data = data where data.length > 0 else {
                return Result.Failure(JetRESTError.ResponseError(underlyngError: error))
            }
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: options)
                let object = try decoder(JSON)
                
                return Result.Success(object)
            }
            catch let e as NSError {
                return Result.Failure(JetRESTError.SerializingError(underlyingError: e))
            }
        }
    }
    
}
