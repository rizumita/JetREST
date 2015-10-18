//
//  JRSerializer.swift
//  JetREST
//
//  Created by 和泉田 領一 on 2015/10/18.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public protocol JRSerializerType: Alamofire.ResponseSerializerType {
    
    typealias ContentsDecoderType: JRDecoderType

}

public protocol JRPageSerializerType: JRSerializerType {
    
    typealias PaginationDecoderType: JRPaginationDecoderType
    
}

public struct JSONSerializer<C: JRDecoderType>: JRSerializerType {
    
    public typealias ContentsDecoderType = C

    public typealias SerializedObject = ContentsDecoderType.ContentType
    
    public typealias ErrorObject = JetRESTError
    
    public var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<SerializedObject, ErrorObject>

    init(contentsDecoder: C, options: NSJSONReadingOptions = .AllowFragments) {
        serializeResponse = { request, response, data, error in
            guard let response = response, let data = data where data.length > 0 else {
                return Result.Failure(JetRESTError.ResponseError(underlyngError: error))
            }
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: options)
                let contents = try contentsDecoder.decode(try contentsDecoder.rawValue(serializedObject: JSON, response: response, data: data))
                
                return Result.Success(contents)
            }
            catch let e as NSError {
                return Result.Failure(JetRESTError.SerializingError(underlyingError: e))
            }
        }
    }

}

public struct JSONPageSerializer<C: JRDecoderType, P: JRPaginationDecoderType>: JRPageSerializerType {
    
    public typealias ContentsDecoderType = C
    
    public typealias PaginationDecoderType = P

    public typealias SerializedObject = (ContentsDecoderType.ContentType, PaginationDecoderType.ContentType)
    
    public typealias ErrorObject = JetRESTError
    
    public var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<SerializedObject, ErrorObject>
    
    init(contentsDecoder: C, paginationDecoder: P, options: NSJSONReadingOptions = .AllowFragments) {
        serializeResponse = { request, response, data, error in
            guard let response = response, let data = data where data.length > 0 else {
                return Result.Failure(JetRESTError.ResponseError(underlyngError: error))
            }
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: options)
                let contents = try contentsDecoder.decode(try contentsDecoder.rawValue(serializedObject: JSON, response: response, data: data))
                let pagination = try paginationDecoder.decode(try paginationDecoder.rawValue(serializedObject: JSON, response: response, data: data))
                
                return Result.Success((contents, pagination))
            }
            catch let e as NSError {
                return Result.Failure(JetRESTError.SerializingError(underlyingError: e))
            }
        }
    }
    
}
