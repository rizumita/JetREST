//
//  JRPaginator.swift
//  JetREST
//
//  Created by 和泉田 領一 on 2015/10/11.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public struct JRPaginator<Q: JRPageRequestType> {
    
    typealias RequestType = Q

    var request: RequestType
    
    var pagination: Q.SerializerType.PaginationDecoderType.ContentType?

    func loadNextPage(handler: Result<Q.SerializerType.SerializedObject, Q.SerializerType.ErrorObject> -> Void) throws {
        try Q.SerializerType.PaginationDecoderType.ContentType.nextPageRequest(pagination: pagination, previousRequest: request).execute(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { (response: Response<Q.SerializerType.SerializedObject, Q.SerializerType.ErrorObject>) -> Void in
            handler(response.result)
        }
    }
    
    init(request: Q) {
        self.request = request
    }
    
}

public protocol JRPaginationType {
    
    static func nextPageRequest<P: JRPaginationType, Q: JRRequestType>(pagination pagination: P?, previousRequest: Q) throws -> Q
    
}
