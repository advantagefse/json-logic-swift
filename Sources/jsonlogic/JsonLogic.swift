//
//  JsonLogic.swift
//  jsonlogic
//
//  Created by Christos Koninis on 06/06/2018.
//  Licensed under LGPL
//

import Foundation
import JSON

enum JSONLogicError: Error, Equatable {
    static func ==(lhs: JSONLogicError, rhs: JSONLogicError) -> Bool {
        switch lhs {
        case canNotParseJSONData:
            return rhs == canNotParseJSONData
        case let canNotConvertResultToType(ltype):
            if case let canNotConvertResultToType(rtype) = rhs {
                return ltype == rtype
            }
            return false
        case .canNotParseJSONRule:
            return lhs == canNotParseJSONRule
        }
    }

    case canNotParseJSONData
    case canNotParseJSONRule
    case canNotConvertResultToType(Any.Type)
}

public func applyRule<T>(_ jsonRule: String, to jsonDataOrNil: String? = nil) throws -> T {
    return try JsonLogic().applyRule(jsonRule, to: jsonDataOrNil)
}

public final class JsonLogic {
    var jsonData: JSON?

    public init() {}
//    public init?(_ jsonRule: String) {
//        if let jsonDataOrNil = jsonDataOrNil {
//            jsonData = JSON(string: jsonDataOrNil)
//        }
//
//        let rule = JSON(string: jsonRule)!
//    }

    public func applyRule<T>(_ jsonRule: String, to jsonDataOrNil: String? = nil) throws -> T {
        var jsonData: JSON?

        if let jsonDataOrNil = jsonDataOrNil {
            jsonData = JSON(string: jsonDataOrNil)
        }

        let rule = JSON(string: jsonRule)!

        let result = try Parser(json: rule ).parse().evalWithData(jsonData)

        let convertedToSwiftStandardType = try result.convertToSwiftTypes()

        switch convertedToSwiftStandardType {
        case let .some(value):
            guard let convertedResult = value as? T else {
                print(" canNotConvertResultToType \(T.self) from \(type(of: value))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            return convertedResult
        default:
            guard let convertedResult = convertedToSwiftStandardType as? T else {
                print(" canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            return convertedResult
        }
    }
}

extension JSON {
    func convertToSwiftTypes() throws -> Any? {
        switch self {
        case .Error:
            throw JSONLogicError.canNotParseJSONData
        case .Null:
            return Optional<Any>.none
        case .Bool:
            return self.bool
        case .Int:
            return Swift.Int(self.int!)
        case .Double:
            return self.double
        case .String:
            return self.string
        case let JSON.Array(array):
            return try array.map { try $0.convertToSwiftTypes() }
        case .Dictionary:
            let o = self.dictionary!
            return try o.mapValues {
                try $0.convertToSwiftTypes()
            }
        }
    }
}
