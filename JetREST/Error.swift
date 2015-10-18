//
//  Error.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/27.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation

public enum JetRESTError: ErrorType {
    
    case BaseURLError
    case MismatchedTypeError(value: AnyObject, requiredType: Any.Type)
    case ResponseError(underlyngError: NSError?)
    case SerializingError(underlyingError: NSError)
    case GeneralError(NSError)
    case PatternSearchError(value: Any, key: String)
    case ConvertCustomStringConvertibleError(value: Any)
    case DecodingError
    case PaginationTypeError
    case PaginationError
    case PageOverflowError
    case UnknownError
    
}
