//
//  JsonLogic.swift
//  jsonlogic
//
//  Created by Christos Koninis on 06/06/2018.
//  Licensed under LGPL
//

import Foundation
import JSON

///  Errors that can be thrown from JsonLogic methods
public enum JSONLogicError: Error, Equatable {
    public static func == (lhs: JSONLogicError, rhs: JSONLogicError) -> Bool {
        switch lhs {
        case let canNotParseJSONData(ltype):
            if case let canNotParseJSONData(rtype) = rhs {
                return ltype == rtype
            }
            return false
        case let canNotConvertResultToType(ltype):
            if case let canNotConvertResultToType(rtype) = rhs {
                return ltype == rtype
            }
            return false
        case let .canNotParseJSONRule(ltype):
            if case let canNotParseJSONRule(rtype) = rhs {
                return ltype == rtype
            }
            return false
        }
    }

    /// Invalid json data was passed
    case canNotParseJSONData(String)

    /// Invalid json rule was passed
    case canNotParseJSONRule(String)

    /// Could not convert the result from applying the rule to the expected type
    case canNotConvertResultToType(Any.Type)
}

/**
    A shortcut method to parse and apply a json logic rule.

    If you need to apply the same rule to multiple json data, it is more efficient to
    instantiate a `JsonLogic` class that will cache and reuse the parsed rule.
*/
public func applyRule<T>(_ jsonRule: String, to jsonDataOrNil: String? = nil) throws -> T {
    return try JsonLogic(jsonRule).applyRule(to: jsonDataOrNil)
}

/**
    It parses json rule strings and executes the rules on provided data.
*/
public final class JsonLogic {
    private let parsedRule: Expression

    /**
    It parses the string containing a json logic and caches the result for reuse.

    All calls to `applyRule()` will use the same parsed rule.

    - parameters:
        - jsonRule: A valid json rule string

    - throws:
      - `JSONLogicError.canNotParseJSONRule`
     If The jsonRule could not be parsed, possible the syntax is invalid
      - `ParseError.UnimplementedExpressionFor(_ operator: String)` :
     If you pass an json logic operation that is not currently implemented
      - `ParseError.GenericError(String)` :
     An error occurred during parsing of the rule
    */
    public init(_ jsonRule: String) throws {
        guard let rule = JSON(string: jsonRule) else {
            throw JSONLogicError.canNotParseJSONRule("Not valid JSON object")
        }
        parsedRule = try Parser(json: rule ).parse()
    }

    /**
    It applies the rule, you can optionally pass data to be used for the rule.

    - parameter jsonDataOrNil: Data for the rule to operate on

    - throws:
      - `JSONLogicError.canNotConvertResultToType(Any.Type)` :
              When the result from the calculation can not be converted to the return type

            //This throws JSONLogicError.canNotConvertResultToType(Double)
            let r: Double = JsonLogic("{ "===" : [1, 1] }").applyRule()
      - `JSONLogicError.canNotParseJSONData(String)` :
     If `jsonDataOrNil` is not valid json
    */
    public func applyRule<T>(to jsonDataOrNil: String? = nil) throws -> T {
        var jsonData: JSON?

        if let jsonDataOrNil = jsonDataOrNil {
            jsonData = JSON(string: jsonDataOrNil)
        }

        let result = try parsedRule.evalWithData(jsonData)

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
// print("canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            return convertedResult
        }
    }
    
    public func parseValue() -> Int64 {
        (((self.parsedRule as? Comparison)?.arg as? ArrayOfExpressions)?.expressions[0] as? SingleValueExpression)?.json.int ?? 1
    }
}

extension JSON {
    func convertToSwiftTypes() throws -> Any? {
        switch self {
        case .Error:
            throw JSONLogicError.canNotParseJSONData("\(self)")
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
