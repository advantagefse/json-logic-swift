//
//  JsonLogic.swift
//  jsonlogic-swift
//
//  Created by Christos Koninis on 06/06/2018.
//

import Foundation
import JSON

enum JSONLogicError : Error, Equatable {
    static func == (lhs: JSONLogicError, rhs: JSONLogicError) -> Bool {
        switch lhs {
        case canNotParseJSONdata:
            return rhs == canNotParseJSONdata;
        case let canNotConvertResultToType(ltype):
            if case let canNotConvertResultToType(rtype) = rhs {
                return ltype == rtype
            }
            return false
        }
    }

    case canNotParseJSONdata
    case canNotConvertResultToType(Any.Type)
}

public class JsonLogic {

    public init() {}

    public func applyRule<T>(_ jsonRule: String, to jsonDataOrNil: String? = nil) throws -> T {
        var jsonData : JSON? = nil

        if let jsonDataOrNil = jsonDataOrNil {
            jsonData = JSON(string: jsonDataOrNil)
        }

        if let tokens: [Token] = try! Tokenizer(jsonString: jsonRule)?.tokens {

            let result = try Parser(tokens: tokens).parseExpression().evalWithData(jsonData)

            switch T.self {
            case is Double.Type:
                return result.number! as! T
            case is Bool.Type:
                return result.bool! as! T
            case is Int.Type:
                return Int(result.number!) as! T
            case is String.Type:
                return result.string! as! T
            default:
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
        }

        throw ParseError.GenericError("Error parsing")
    }
}

