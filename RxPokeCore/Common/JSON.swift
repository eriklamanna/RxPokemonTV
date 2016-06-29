//
//  JSON.swift
//  RxPokeTV
//
//  Created by Erik LaManna on 6/29/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Self
}

protocol JSONEncodable {
    func encodeJSON() -> NSDictionary
}

/** 
 * Struct for parsing and handling JSON data, including fetching required fields. If parsing fails,
 * the various functions will throw an error indicating the issue.
 */
public struct JSON {
    
    public enum Error: ErrorType {
        case MustBeADictionary
        case MissingRequiredElement(String)
        case MustBeAnInt(String)
        case MustBeAString(String)
        case MustBeAnArray(String)
        case MustBeKeyValue(String)
        case MustBeADouble(String)
    }
    
    let dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    public static func dictionary(obj: AnyObject) throws -> JSON {
        
        guard let dictionary = obj as? NSDictionary else {
            throw Error.MustBeADictionary
        }
        
        return JSON(dictionary: dictionary)
    }
    
    public func requiredInt(key: String) throws -> Int {
        return try int(key, required: true)!
    }
    
    public func int(key: String, required: Bool = false) throws -> Int? {
        guard let value = try value(key, required: required) else { return nil }
        
        if value is NSNull {
            return nil
        }
        
        guard let int = value as? Int else {
            throw Error.MustBeAnInt(key)
        }
        return int
    }
    
    public func requiredDouble(key: String) throws -> Double {
        return try double(key, required: true)!
    }
    
    public func double(key: String, required: Bool = false) throws -> Double? {
        guard let value = try value(key, required: required) else { return nil }
        
        if value is NSNull {
            return nil
        }
        
        guard let double = value as? Double else {
            throw Error.MustBeADouble(key)
        }
        return double
    }
    
    public func requiredString(key: String) throws -> String {
        return try string(key, required: true)!
    }
    
    public func string(key: String, required: Bool = false) throws -> String? {
        guard let value = try value(key, required: required) else { return nil }

        if value is NSNull {
            return nil
        }
        
        guard let str = value as? String else {
            throw Error.MustBeAString(key)
        }
        
        return str
    }
    
    public func requiredArray(key: String) throws -> [AnyObject] {
        return try array(key, required: true)!
    }
    
    public func array(key: String, required: Bool = false) throws -> [AnyObject]? {
        guard let value = try value(key, required: required) else { return nil }
        
        if value is NSNull {
            return nil
        }
        
        guard let array = value as? NSArray else {
            throw Error.MustBeAnArray(key)
        }
        return array as [AnyObject]?
    }
    
    public func requiredObjects(key: String) throws -> [JSON] {
        return try objects(key, required: true)!
    }
    
    public func objects(key: String, required: Bool = false) throws -> [JSON]? {
        return try array(key, required: required)?.map { obj in try JSON.dictionary(obj) }
    }

    public func requiredKeyValue(key: String) throws -> [String: AnyObject] {
        return try keyValue(key, required: true)!
    }

    public func keyValue(key: String, required: Bool = false) throws -> [String: AnyObject]? {
        guard let value = try value(key, required: required) else { return nil }

        if value is NSNull {
            return nil
        }

        guard let keyValue = value as? [String: AnyObject] else {
            throw Error.MustBeKeyValue(key)
        }

        return keyValue as [String: AnyObject]?
    }

    public func requiredValue(key: String) throws -> AnyObject {
        return try value(key, required: true)!
    }
    
    public func value(key: String, required: Bool = false) throws -> AnyObject? {
        let obj = dictionary[key]
        if required && obj == nil {
            throw Error.MissingRequiredElement(key)
        }
        return obj
    }
}