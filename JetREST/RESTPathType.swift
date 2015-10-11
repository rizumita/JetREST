//
//  RESTPathType.swift
//  JetREST
//
//  Created by 和泉田領一 on 2015/09/29.
//  Copyright © 2015年 CAPH. All rights reserved.
//

import Foundation

public protocol RESTPathType: CustomStringConvertible {
    
    var rawPath: String { get }
    
    func expandPath(object object: Any) throws -> String
    
    func expandPath(dictionary dictionary: [String : AnyObject]) throws -> String
    
}

public extension RESTPathType {
    
    func expandPath(object object: Any) throws -> String {
        return try rawPath.componentsSeparatedByString("/").map { (component: String) -> String in
            return component.isPattern ? try retrieveValue(fromObject: object, keyPath: component.substringFromIndex(component.startIndex.advancedBy(1)).componentsSeparatedByString(".")).description : component
            }.joinWithSeparator("/")
    }

    func expandPath(dictionary dictionary: [String : AnyObject]) throws -> String {
        return try rawPath.componentsSeparatedByString("/").map { (component: String) -> String in
            return component.isPattern ? try retrieveValue(fromDictionary: dictionary, keyPath: component.substringFromIndex(component.startIndex.advancedBy(1)).componentsSeparatedByString(".")).description : component
            }.joinWithSeparator("/")
    }
    
    var description: String {
        return rawPath
    }
    
}

extension String: RESTPathType {
    
    public var rawPath: String { return self }
    
}

extension String {
    
    var isPattern: Bool {
        return characters.count > 0 && self[startIndex] == ":"
    }
    
}

func retrieveValue(fromObject object: Any, keyPath: [String]) throws -> CustomStringConvertible {
    if keyPath.count == 0 {
        if object is CustomStringConvertible {
            return object as! CustomStringConvertible
        } else {
            throw JetRESTError.ConvertCustomStringConvertibleError(value: object)
        }
    }
    
    var mutableKeyPath = keyPath
    let key = mutableKeyPath.removeFirst()
    
    let mirror = Mirror(reflecting: object)
    
    let value = mirror.children.filter { child -> Bool in
        child.0 == key
        }.first.map { $0.1 }
    
    if let value = value {
        return try retrieveValue(fromObject: value, keyPath: mutableKeyPath)
    } else {
        throw JetRESTError.PatternSearchError(value: object, key: key)
    }
}

func retrieveValue(fromDictionary dictionary: [String : AnyObject], keyPath: [String]) throws -> CustomStringConvertible {
    var mutableKeyPath = keyPath
    let key = mutableKeyPath.removeFirst()

    if let object = dictionary[key] {
        let mirror = Mirror(reflecting: object)
        if case .Dictionary? = mirror.displayStyle {
            return try retrieveValue(fromDictionary: object as! [String : AnyObject], keyPath: mutableKeyPath)
        } else {
            return try retrieveValue(fromObject: object, keyPath: mutableKeyPath)
        }
    } else {
        throw JetRESTError.PatternSearchError(value: dictionary, key: key)
    }
}
