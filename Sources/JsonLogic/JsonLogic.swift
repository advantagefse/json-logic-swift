//
//  JsonLogic.swift
//  JsonLogic
//
//  Created by Christos Koninis on 06/06/2018.
//  Licensed under MIT
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

public func applyRule<T>(_ jsonRule: JSON, to jsonDataOrNil: String? = nil) throws -> T {
    return try JsonLogic(jsonRule).applyRule(to: jsonDataOrNil)
}
public func applyRule<T>(_ jsonRule: JSON, to jsonOrNil: JSON? = nil) throws -> T {
    return try JsonLogic(jsonRule).applyRuleInternal(to: jsonOrNil)
}

public func applyRule<T>(_ jsonRule: JSON, to jsonDataOrNil: String? = nil, customOperators: [String: (JSON?) -> JSON]?) throws -> T {
    return try JsonLogic(jsonRule, customOperators: customOperators).applyRule(to: jsonDataOrNil)
}

public func applyRule<T>(_ jsonRule: JSON, to jsonOrNil: JSON? = nil, customOperators: [String: (JSON?) -> JSON]?) throws -> T {
    return try JsonLogic(jsonRule, customOperators: customOperators).applyRuleInternal(to: jsonOrNil)
}

/**
    It parses json rule strings and executes the rules on provided data.
*/
public final class JsonLogic {
    // The parsed json string to an Expression that can be used for evaluation upon specific data
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
    public convenience init(_ jsonRule: String) throws {
        try self.init(jsonRule, customOperators: nil)
    }
    public convenience init(_ jsonRule: JSON) throws {
        try self.init(jsonRule, customOperators: nil)
    }

    /**
    It parses the string containing a json logic and caches the result for reuse.

    All calls to `applyRule()` will use the same parsed rule.

    - parameters:
        - jsonRule: A valid json rule string
        - customOperators: custom operations that will be used during evalution

    - throws:
      - `JSONLogicError.canNotParseJSONRule`
     If The jsonRule could not be parsed, possible the syntax is invalid
      - `ParseError.UnimplementedExpressionFor(_ operator: String)` :
     If you pass an json logic operation that is not currently implemented
      - `ParseError.GenericError(String)` :
     An error occurred during parsing of the rule
    */
    public init(_ jsonRule: String, customOperators: [String: (JSON?) -> JSON]?) throws {
        guard let rule = JSON(string: jsonRule) else {
            throw JSONLogicError.canNotParseJSONRule("Not valid JSON object")
        }
        parsedRule = try Parser(json: rule, customOperators: customOperators).parse()
    }
    public init(_ jsonRule: JSON, customOperators: [String: (JSON?) -> JSON]?) throws {
        parsedRule = try Parser(json: jsonRule, customOperators: customOperators).parse()
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
         return try self.applyRuleInternal(to: jsonData)
    }
    
    public func applyRuleInternal<T>(to jsonData: JSON? = nil) throws -> T {

        let result = try parsedRule.evalWithData(jsonData)

        let convertedToSwiftStandardType = try result.convertToSwiftTypes()

        switch convertedToSwiftStandardType {
        case let .some(value):
        // if T is a boolean-like value return the truthy value of result
            if let _ = true as? T {
                return result.truthy() as! T
            }
            guard let convertedResult = value as? T else {
                print(" canNotConvertResultToType \(T.self) from \(type(of: value))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            return convertedResult
        default:
            // workaround for swift bug that cause to fail when casting
            // from generic type that resolves to Ant? to Any? in certain compilers, see SR-14356
            #if compiler(>=5) && swift(<5)
            guard let convertedResult = (convertedToSwiftStandardType as Any) as? T else {
                // print("canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            #else
            guard let convertedResult = convertedToSwiftStandardType as? T else {
                // print("canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            #endif
            return convertedResult
        }
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
        case .Date:
            return self.date
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
