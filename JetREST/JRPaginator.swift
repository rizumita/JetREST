//
//  JRPaginator.swift
//  JetREST
//
//  Created by 和泉田 領一 on 2015/10/11.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public struct JRPaginator<S: JRPageSerializerType> {

    var request: JRRequest

    var serializer: S
    
    var pagination: S.PaginationDecoderType.ContentType?

    func loadNextPage(handler: Result<S.SerializedObject, S.ErrorObject> -> Void) throws {
        try S.PaginationDecoderType.ContentType.nextPageRequest(pagination: pagination, previousRequest: request).execute(serializer: serializer, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { (response: Response<S.SerializedObject, S.ErrorObject>) -> Void in
            handler(response.result)
        }
    }
    
    init(request: JRRequest, serializer: S) {
        self.request = request
        self.serializer = serializer
    }
    
}

public protocol JRPaginationType {
    
    static func nextPageRequest<P: JRPaginationType, Q: JRRequestType>(pagination pagination: P?, previousRequest: Q) throws -> Q
    
}
