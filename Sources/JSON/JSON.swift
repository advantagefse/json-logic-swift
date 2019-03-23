//
//  JSON.swift
//  JSON
//
//  Created by Christos Koninis on 09/03/2019.
//  Licensed under LGPL
//

import Foundation

public enum JSON: Equatable {
    case Null
    case Array([JSON])
    case Dictionary([String: JSON])
    case Int(Int64)
    case Double(Double)
    case String(String)
    case Bool(Bool)
    case Error(JSON2Error)

    public enum ContentType {
        case error, null, bool, number, string, array, object
    }

    public var type: ContentType {
        switch self {
        case .Error:
            return .error
        case .Null:
            return .null
        case .Bool:
            return .bool
        case .Int, .Double:
            return .number
        case .String:
            return .string
        case .Array:
            return .array
        case .Dictionary:
            return .object
        }
    }

    public enum JSON2Error: Error, Equatable, Hashable {
        case failedToParse
        case notJSONValue
        case indexOutOfRange(Int)
        case keyNotFound(String)
        case notSubscriptableType(ContentType)
        case NSError(NSError)
    }

    public init() {
        self = .Null
    }

    public init(_ array: [JSON]) {
        self = .Array(array)
    }

    public init(_ dictionary: [String: JSON]) {
        self = .Dictionary(dictionary)
    }

    //swiftlint:disable syntactic_sugar
    public init(_ json: Any) {
        switch json {
        case let array as Swift.Array<Any>:
            self = .Array(array.map({JSON($0)}))
        case let dictionary as Swift.Dictionary<String, Any>:
            self = .Dictionary(dictionary.mapValues({ JSON($0) }))
        case let string as Swift.String:
            self = .String(string)
        case let number as NSNumber:
            switch Swift.String(cString: number.objCType) {
            case "i", "s", "l", "q", "I", "S", "L", "Q":
                self = .Int(number.int64Value)
            case "f", "d":
                self = .Double(number.doubleValue)
            case "B", "c", "C":
                self = .Bool(number.boolValue)
            case "*":
                self = .String(Swift.String(number.int8Value))
            default:
                self = .Error(.notJSONValue)
            }
        case Optional<Any>.none, nil, is NSNull:
            self = .Null
        case let bool as Bool:
            self = .Bool(bool)
        case let int as Swift.Int:
            self = .Int(Int64(int))
        case let double as Swift.Double:
            self = .Double(double)
        default:
            self = .Error(.NSError(NSError(domain: "Can't convert value \(json) to JSON", code: 1)))
        }
    }
    //swiftlint:enable syntactic_sugar

    public init(_ data: Data) {
        do {
            self.init(try JSONSerialization.jsonObject(with: data, options: [.allowFragments]))
        } catch let error as NSError {
            self = .Error(.NSError(error))
        } catch {
            self = .Error(.failedToParse)
        }
    }

    public init?(string: String, encoding: String.Encoding = .utf8) {
        guard let data = string.data(using: encoding) else {
            return nil
        }
        self.init(data)
    }

    //Strict Equality
    public static func === (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case let (.Bool(x), .Bool(y)):
            return x == y
        case let (.Double(x), .Double(y)):
            return x == y
        case let (.Int(x), .Int(y)):
            return x == y
        case let (.String(lhsString), .String(rhsString)):
            return lhsString == rhsString
        case let (.Array(lhsArray), .Array(rhsArray)) where lhsArray.count == rhsArray.count:
            for (idx, value) in lhsArray .enumerated() where value != rhsArray[idx] {
                    return false
            }
            return  true
        case (.Null, .Null):
            return true
        default:
            return false
        }
    }

    //Strict inEquality
    public static func !== (lhs: JSON, rhs: JSON) -> Bool {
        return !(lhs === rhs)
    }

    //swiftlint:disable:next cyclomatic_complexity function_body_length
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case let (.Double(x), .Double(y)):
            return x == y
        case let (.Int(x), .Int(y)):
            return x == y
        case let (.Double(x), .Int(y)):
            return x == Swift.Double(y)
        case let (.Int(x), .Double(y)):
            return Swift.Double(x) == y
        case (_, .Bool):
            return lhs == (try? toNumber(rhs))
        case (.Bool, _):
            return (try? toNumber(lhs)) == rhs
        case let (.String(lhsString), .String(rhsString)):
            return lhsString == rhsString
        case (.String, .Int):
            guard let number = try? toNumber(lhs) else {
                return false
            }
            return number == rhs
        case (.String, .Double):
            guard let number = try? toNumber(lhs) else {
                return false
            }
            return number == rhs
        case (.Double, .String):
            guard let number = try? toNumber(rhs) else {
                return false
            }
            return lhs == number
        case (.Int, .String):
            guard let number = try? toNumber(rhs) else {
                return false
            }
            return lhs == number
        case let (.Array(lhsArray), .Array(rhsArray)) where lhsArray.count == rhsArray.count:
            return lhsArray == rhsArray
        case let (.Array(array), _) where array.count <= 1:
            return (array.first ?? .Null) == rhs
        case let (_, .Array(array)) where array.count <= 1:
            return lhs == (array.first ?? .Null)
        case (_, .Null):
            return lhs == JSON(0)
        case (.Null, _):
            return JSON(0) == rhs
        default:
            return false
        }
    }

    public static func + (lhs: JSON, rhs: JSON) -> JSON {
        switch (lhs, rhs) {
        case let (.Double(x), .Double(y)):
            return JSON(x + y)
        case let (.Int(x), .Int(y)):
            return JSON(x + y)
        case let (.Double(x), .Int(y)):
            return JSON(x + Swift.Double(y))
        case let (.Int(x), .Double(y)):
            return JSON(y + Swift.Double(x))
        default:
            return JSON.Null
        }
    }

    public static prefix func - (json: JSON) -> JSON {
        switch json {
        case let .Double(x):
            return JSON(-x)
        case let .Int(x):
            return JSON(-x)
        default:
            return JSON.Null
        }
    }

    public static func - (lhs: JSON, rhs: JSON) -> JSON {
        return lhs + (-rhs)
    }

    public static func * (lhs: JSON, rhs: JSON) -> JSON {
        switch (lhs, rhs) {
        case let (.Double(x), .Double(y)):
            return JSON(x * y)
        case let (.Int(x), .Int(y)):
            return JSON(x * y)
        case let (.Double(x), .Int(y)):
            return JSON(x * Swift.Double(y))
        case let (.Int(x), .Double(y)):
            return JSON(y * Swift.Double(x))
        default:
            return JSON.Null
        }
    }

    public static func / (lhs: JSON, rhs: JSON) -> JSON {
        switch (lhs, rhs) {
        case let (.Double(x), .Double(y)):
            return .Double(x / y)
        case let (.Int(x), .Int(y)):
            if x % y == 0 {
                return .Int(x / y)
            }
            return .Double(Swift.Double(x) / Swift.Double(y))
        case let (.Double(x), .Int(y)):
            return .Double(x / Swift.Double(y))
        case let (.Int(x), .Double(y)):
            return .Double(Swift.Double(x) / y)
        default:
            return JSON.Null
        }
    }

    public static func % (lhs: JSON, rhs: JSON) -> JSON {
        switch (lhs, rhs) {
        case let (.Double(x), .Double(y)):
            return .Double(x.truncatingRemainder(dividingBy: y))
        case let (.Int(x), .Int(y)):
            return .Int(x % y)
        case let (.Double(x), .Int(y)):
            return .Double(x.truncatingRemainder(dividingBy: Swift.Double(y)))
        case let (.Int(x), .Double(y)):
            return .Double(Swift.Double(x).truncatingRemainder(dividingBy: y))
        default:
            return JSON.Null
        }
    }

    public var bool: Bool? { if case let .Bool(value) = self { return value }; return nil }

    public var int: Int64? { if case let .Int(value) = self { return value }; return nil }

    public var double: Double? { if case let .Double(value) = self { return value }; return nil }

    public var string: String? { if case let .String(value) = self { return value }; return nil }

    public var array: [JSON]? { if case let .Array(value) = self { return value }; return nil }

    //swiftlint:disable:next line_length
    public var dictionary: [String: JSON]? { if case let .Dictionary(value) = self { return value }; return nil }
}

extension JSON: Comparable {
    public static func < (lhs: JSON, rhs: JSON) -> Bool {
        return (try? lessThanWithTypeCoercion(lhs, rhs)) ?? false
    }

    fileprivate static func toNumber(_ json: JSON) throws -> JSON {
        let result = json.toNumber()
        switch json.toNumber() {
        case .Double, .Int:
            return result
        default:
            throw NSError()
        }
    }

    //swiftlint:disable:next cyclomatic_complexity function_body_length
    private static func lessThanWithTypeCoercion(_ lhs: JSON, _ rhs: JSON) throws -> Bool {
        switch (lhs, rhs) {
        case let (.Double(x), .Double(y)):
            return x < y
        case let (.Int(x), .Int(y)):
            return x < y
        case let (.Double(x), .Int(y)):
            return x < Swift.Double(y)
        case let (.Int(x), .Double(y)):
            return Swift.Double(x) < y
        case let (.Array(lhsArray), .Array(rhsArray)):
            return try lessThanWithTypeCoercion(lhsArray.first ?? .Null, rhsArray.first ?? .Null)
        case (_, .Bool):
            return try lessThanWithTypeCoercion(lhs, (try toNumber(rhs)))
        case (.Bool, _):
            return try lessThanWithTypeCoercion(toNumber(lhs), rhs)
        case let (.String(lhsString), .String(rhsString)):
            return lhsString < rhsString
        case (.String, .Int):
            return try lessThanWithTypeCoercion(try toNumber(lhs), rhs)
        case (.Int, .String):
            return try lessThanWithTypeCoercion(lhs, (try toNumber(rhs)))
        case (.String, .Double):
            return try lessThanWithTypeCoercion(try toNumber(lhs), rhs)
        case (.Double, .String):
            return try lessThanWithTypeCoercion(lhs, (try toNumber(rhs)))
        case let (.Array(array), _):
            return try lessThanWithTypeCoercion(array.first ?? .Null, rhs)
        case let (_, .Array(array)):
            return try lessThanWithTypeCoercion(lhs, array.first ?? .Null)
        case (_, .Null):
            return try lessThanWithTypeCoercion(lhs, JSON(0))
        case (.Null, _):
            return try lessThanWithTypeCoercion(JSON(0), rhs)
        default:
            throw NSError()
        }
    }

    public static func > (lhs: JSON, rhs: JSON) -> Bool {
        guard let isLessThan = try? lessThanWithTypeCoercion(lhs, rhs) else {
            return false
        }
        return !isLessThan && (lhs != rhs)
    }

    public static func >= (lhs: JSON, rhs: JSON) -> Bool {
        do {
            let isLessThan = try lessThanWithTypeCoercion(lhs, rhs)
            return !isLessThan || (lhs == rhs)
        } catch {
            return false
        }
    }

    public static func <= (lhs: JSON, rhs: JSON) -> Bool {
        do {
            let isLessThan = try lessThanWithTypeCoercion(lhs, rhs)
            return isLessThan || (lhs == rhs)
        } catch {
            return false
        }
    }
}

extension JSON: Hashable {
}

extension JSON: ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral, ExpressibleByBooleanLiteral,
        ExpressibleByNilLiteral, ExpressibleByStringLiteral, ExpressibleByDictionaryLiteral {
    public init(stringLiteral value: String) {
        self = .String(value)
    }

    public init(nilLiteral: ()) {
        self = .Null
    }

    public init(arrayLiteral elements: Int...) {
        self.init(elements)
    }

    public init(booleanLiteral value: BooleanLiteralType) {
        self = .Bool(value)
    }

    public init(dictionaryLiteral value: (Swift.String, JSON)...) {
        var result: [Swift.String: JSON] = [:]
        for pair in value {
            result[pair.0] = pair.1
        }
        self = .Dictionary(result)
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self = .Int(Int64(value))
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self = .String(value)
    }

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = .String(value)
    }
}

extension JSON {
    /**
    If the JSON element is of type .Array, this will return/set the idx element.

    Trying to set an value to an non .Array type will result in runtime error.
    */
    public subscript(_ idx: Int) -> JSON {
        get {
            switch self {
                    //we want the nested error to propagate unaltered
            case .Error:
                return self
            case let .Array(array):
                guard idx < array.count else { return .Error(.indexOutOfRange(idx)) }
                return array[idx]
            default:
                return .Error(.notSubscriptableType(self.type))
            }
        }
        set {
            switch self {
            case .Array(var array):
                if idx < array.count {
                    array[idx] = newValue
                } else {
                    for _ in array.count ..< idx {
                        array.append(.Null)
                    }
                    array.append(newValue)
                }
                self = .Array(array)
            default:
                fatalError("attempted to subscript \"\(self)\" which is not an array")
            }
        }
    }

    /**
    If the JSON element is of type .Dictionary, this will return/set a element by it's key.

    Trying to set an value to an non .Dictionary type will result in runtime error.
    */
    public subscript(_ key: Key) -> JSON {
        get {
            switch self {
                    //we want the nested error to propagate unaltered
            case .Error:
                return self
            case let .Dictionary(dictionary):
                return dictionary[key] ?? .Error(.keyNotFound(key))
            default:
                return .Error(.notSubscriptableType(self.type))
            }
        }
        set {
            switch self {
            case var .Dictionary(dictionary):
                dictionary[key] = newValue
                self = .Dictionary(dictionary)
            default:
                fatalError("\"\(self)\" is not an object")
            }
        }
    }
}

extension JSON {
    /**
    Evaluates the truth value of the JSON object according to the json logic.

    - Returns: the truth value of the JSON object
    */
    public func thruthy() -> Bool {
        switch self {
        case let .Bool(bool):
            return bool
        case let .Int(number):
            return number != 0
        case let .Double(number):
            return number != 0.0
        case let .String(string):
            return !string.isEmpty
        case let .Array(array):
            return !array.isEmpty
        case .Dictionary:
            return true
        default:
            return false
        }
    }
}

extension JSON {
    /**
    Tries to convert the current JSON to a number.

    - Returns: a converted JSON number value (either .Double or .Int) or .Null if it fails
    */
    public func toNumber() -> JSON {
        switch self {
        case let .Bool(bool):
            return bool ? 1 : 0
        case .Null:
            return 0
        case .Int:
            return self
        case .Double:
            return self
        case let .String(string):
            guard let integer = Swift.Int(string) else {
                guard let float = Swift.Double(string) else {
                    return JSON.Null
                }
                return JSON(float)
            }
            return JSON(integer)
        default:
            return JSON.Null
        }
    }
}
