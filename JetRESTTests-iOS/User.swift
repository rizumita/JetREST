//
//  User.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/26.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation
@testable import JetREST
import Himotoki

enum Sex: Int {

    case Male = 0, Female = 1, Unknown = 2
    
    static func get(value: Int?) -> Sex {
        switch value {
        case .Some(0):
            return .Male
        case .Some(1):
            return .Female
        case _:
            return .Unknown
        }
    }

}

struct User: Decodable {
    
    let id: Int
    let name: String
    let sex: Sex
    
    init(id: Int, name: String, sex: Int? = 2) {
        self.id = id
        self.name = name
        self.sex = Sex.get(sex)
    }
    
    static func decode(e: Extractor) throws -> User {
        return try build(User.init)(
            e <| "id",
            e <| "name",
            e <|? "sex"
        )
    }

}
