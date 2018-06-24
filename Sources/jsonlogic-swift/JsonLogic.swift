//
//  JsonLogic.swift
//  jsonlogic-swift
//
//  Created by Christos Koninis on 06/06/2018.
//

import Foundation

//BNF
// var_expression -> var_keyword array_single_string | var_keyword single_string

public protocol Value {
    func value() -> Bool?
    func value() -> Int?
    func value() -> String?

    //Dynamic casting, or throw at runtimme exception if the value is not supported
    func value<T>() -> T?
}

extension Bool: Value {
    public func value() -> Bool? {
        return self
    }

    public func value() -> Int? {
        switch self {
        case true:
            return 1
        default:
            return 0
        }
    }

    public func value() -> String? {
        return "\(self)"
    }

    public func value<T>() -> T? {
        return nil
    }
}

extension String: Value {
    public func value() -> Bool? {
        return false
    }

    public func value() -> Int? {
        return 0
    }

    public func value() -> String? {
        return self
    }

    public func value<T>() -> T? {
        return nil
    }
}

extension Int: Value {
    public func value() -> Bool? {
        return self == 0
    }

    public func value() -> Int? {
        return self
    }

    public func value() -> String? {
        return "\(self)"
    }

    public func value<T>() -> T? {
        return nil
    }
}

public class JsonLogic {

    public init() {
    }

    public func applyRule<T : Value>(_ jsonString: String, to jsonData: String? = nil) throws -> T {
        if let data = jsonData?.data(using: .utf8) {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            if let tokens: [Token] = try! Tokenizer(jsonString: jsonString)?.tokens {
                let result: T? = try Parser(tokens: tokens).parse().evalWithData(dataDictionary)
                return result!
            }
            else {
            }
        } else {
            print("Could not convert jsonString to Data using utf8 encoding")
        }

        throw ParseError.GenericError("Error parsing")
    }
}

