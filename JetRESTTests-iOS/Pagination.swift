//
//  Pagination.swift
//  JetREST
//
//  Created by 和泉田 領一 on 2015/10/18.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
@testable import JetREST
import Himotoki

struct Pagination: JRPaginationType, Decodable {
    
    let total: Int
    let totalPages: Int
    let offset: Int
    
//    static func firstPageRequest<Q: JRRequestType>(baseRequset: Q) -> Q {
//        var parameters = baseRequset.parameters ?? [String : AnyObject]()
//        parameters["page"] = 1
//        return Q(method: baseRequset.method, URL: baseRequset.URL, parameters: parameters, parameterEncoding: baseRequset.parameterEncoding, headers: baseRequset.headers)
//    }
//
    static func nextPageRequest<P: JRPaginationType, Q: JRRequestType>(pagination pagination: P?, previousRequest: Q) throws -> Q {
        guard pagination == nil || pagination is Pagination else {
            throw JetRESTError.PaginationTypeError
        }
        
        var parameters = previousRequest.parameters ?? [String : AnyObject]()
        
        if let pagination = pagination {
            if let page = parameters["page"] as? Int {
                if page > (pagination as! Pagination).totalPages {
                    throw JetRESTError.PageOverflowError
                } else {
                    parameters["page"] = page
                }
            } else {
                throw JetRESTError.PaginationError
            }
        } else {
            parameters["page"] = 1
        }
        
        return Q(method: previousRequest.method, URL: previousRequest.URL, parameters: parameters, parameterEncoding: previousRequest.parameterEncoding, headers: previousRequest.headers)
    }

    init(total: Int, totalPages: Int, offset: Int) {
        self.total = total
        self.totalPages = totalPages
        self.offset = offset
    }
    
    static func decode(e: Extractor) throws -> Pagination {
        return try build(Pagination.init)(
            e <| "total",
            e <| "total_pages",
            e <| "offset"
        )
    }

}
