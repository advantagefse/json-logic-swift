//
//  JsonLogic.swift
//  jsonlogic-swift
//
//  Created by Christos Koninis on 06/06/2018.
//

import Foundation
import JSON

public protocol Value {
    func value() -> Bool?
    func value() -> Int?
    func value() -> String?

    //Dynamic casting, or throw at runtimme exception if the value is not supported
//    func value<T>() -> T?
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

//    public func value<T>() -> T? {
//        return nil
//    }
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

//    public func value<T>() -> T? {
//        return nil
//    }
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

//    public func value<T>() -> T? {
//        return nil
//    }
}

extension Double: Value {
    public func value() -> Bool? {
        return self == 0.0
    }

    public func value() -> Int? {
        return Int(self)
    }

    public func value() -> String? {
        return "\(self)"
    }

//    public func value<T>() -> T? {
//        return nil
//    }
}

public class JsonLogic {

    public init() {
    }

    public func applyRule<T : Value>(_ jsonString: String, to jsonDataOrNil: String? = nil) throws -> T {

        let jsonData = jsonDataOrNil ?? "{}"

        if let data = jsonData.data(using: .utf8) {
            let jSON = JSON(string: jsonData)
//            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

//            [""].filter({ type(of:$0) == String.self })

            if let tokens: [Token] = try! Tokenizer(jsonString: jsonString)?.tokens {

                switch T.self {
                case let t as Bool.Type:
                    return try Parser(tokens: tokens).parseExpression().evalWithData(jSON).bool! as! T

//                    return try Parser(tokens: tokens).parse().evalWithData(jSON).bool as! T
                case let t as Int.Type:
                    return try Int(Parser(tokens: tokens).parseExpression().evalWithData(jSON).number!) as! T
                case let t as String.Type:

                    return try Parser(tokens: tokens).parseExpression().evalWithData(jSON).string! as! T

//                    return try "\(String(describing: Parser(tokens: tokens).parse().evalWithData(jSON).string))" as! T
                default:
                    throw ParseError.GenericError("Do not know how to convert to result type \(T.self)")
                }
            }
            else {
            }
        } else {
            print("Could not convert jsonString to Data using utf8 encoding")
        }

        throw ParseError.GenericError("Error parsing")
    }
}

