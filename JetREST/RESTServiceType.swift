//
//  RESTServiceType.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/26.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
import Alamofire

public protocol RESTServiceType {
    
    static var baseURL: NSURL? { get }
    
}
