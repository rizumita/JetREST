//
//  JRDecoderType.swift
//  JetREST
//
//  Created by 和泉田 領一 on 2015/10/18.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public protocol JRDecoderType {
    
    typealias ContentType
    
    typealias RawValueType

    var decode: RawValueType throws -> ContentType { get }
    
    func rawValue(serializedObject serializedObject: AnyObject, response: NSHTTPURLResponse, data: NSData) throws -> RawValueType
    
}

public protocol JRPaginationDecoderType: JRDecoderType {
    
    typealias ContentType: JRPaginationType
    
}

public struct HeaderDecoder<T>: JRDecoderType {
    
    public typealias ContentType = T
    
    public typealias RawValueType = [NSObject : AnyObject]
    
    public let decode: RawValueType throws -> ContentType
    
    public func rawValue(serializedObject serializedObject: AnyObject, response: NSHTTPURLResponse, data: NSData) throws -> RawValueType {
        return response.allHeaderFields
    }
    
}

public struct JSONDecoder<T>: JRDecoderType {
    
    public typealias ContentType = T
    
    public typealias RawValueType = AnyObject
    
    let keyPath: String?
    
    public let decode: AnyObject throws -> ContentType
    
    public func rawValue(serializedObject serializedObject: AnyObject, response: NSHTTPURLResponse, data: NSData) throws -> RawValueType {
        guard let keyPath = keyPath else {
            return serializedObject
        }
        
        let mirror = Mirror(reflecting: serializedObject)
        switch mirror.displayStyle {
        case .Dictionary?:
            if let result = (serializedObject as! NSDictionary).valueForKeyPath(keyPath) {
                return result
            } else {
                throw JetRESTError.DecodingError
            }
        case _:
            throw JetRESTError.DecodingError
        }
    }
    
    init(keyPath: String? = nil, decode: AnyObject throws -> ContentType) {
        self.keyPath = keyPath
        self.decode = decode
    }
    
}

public struct JSONPaginationDecoder<T: JRPaginationType>: JRPaginationDecoderType {
    
    public typealias ContentType = T
    
    public typealias RawValueType = AnyObject
    
    let keyPath: String?
    
    public let decode: AnyObject throws -> ContentType
    
    public func rawValue(serializedObject serializedObject: AnyObject, response: NSHTTPURLResponse, data: NSData) throws -> RawValueType {
        guard let keyPath = keyPath else {
            return serializedObject
        }
        
        let mirror = Mirror(reflecting: serializedObject)
        switch mirror.displayStyle {
        case .Dictionary?:
            if let result = (serializedObject as! NSDictionary).valueForKeyPath(keyPath) {
                return result
            } else {
                throw JetRESTError.DecodingError
            }
        case _:
            throw JetRESTError.DecodingError
        }
    }
    
    init(keyPath: String? = "pagination", decode: AnyObject throws -> ContentType) {
        self.keyPath = keyPath
        self.decode = decode
    }
    
}
