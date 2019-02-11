//
//  JsonLogic.swift
//  jsonlogic-swift
//
//  Created by Christos Koninis on 06/06/2018.
//

import Foundation
import JSON

enum JSONLogicError: Error, Equatable {
    static func == (lhs: JSONLogicError, rhs: JSONLogicError) -> Bool {
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

public class JsonLogic {

    public init() {}

    public func applyRule<T>(_ jsonRule: String, to jsonDataOrNil: String? = nil) throws -> T {
        var jsonData: JSON?

        if let jsonDataOrNil = jsonDataOrNil {
            jsonData = JSON(string: jsonDataOrNil)
        }

        let result = try Parser(json: JSON(string: jsonRule)).parse().evalWithData(jsonData)

        guard let convertedResult = try result.convertToSwiftTypes() as? T else {
            throw JSONLogicError.canNotConvertResultToType(T.self)
        }
        return convertedResult
    }

//    public func applyRule(_ jsonRule: String, to jsonDataOrNil: String?) -> Any?  {
//        var jsonData: JSON?
//
//        if let jsonDataOrNil = jsonDataOrNil {
//            jsonData = JSON(string: jsonDataOrNil)
//        }
//
//        let result = try? Parser(json: JSON(string: jsonRule)).parse().evalWithData(jsonData)
//
//        do {
//            return try result?.convertToSwiftStandarObjects()
//        }
//        catch {
//            return nil
//        }
//    }
}

extension JSON {
    func convertToSwiftTypes() throws -> Any? {
        switch self {
        case .Error:
            throw JSONLogicError.canNotParseJSONData
        case .Null:
            return nil
        case .Bool:
            return self.bool!
        case .Number:
            let n = self.number!
            if let int = Int(exactly: n) {
                return int
            }
            return n
        case .String:
            return self.string!
        case .Array:
            return try self.map { try $0.1.convertToSwiftTypes() }
        case .Object:
            let o = self.object!
            return try o.mapValues { try $0.convertToSwiftTypes() }
        }
    }
}
