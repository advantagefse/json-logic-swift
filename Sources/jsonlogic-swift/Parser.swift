//
//  Parser.swift
//  jsonlogic-swift
//
//  Created by Christos Koninis on 16/06/2018.
//

import Foundation
import JSON

public enum ParseError: Error {
    case UnimplementedExpressionFor(_ operator: String)
    case GenericError(String)
}

protocol Expression {
    func evalWithData(_ data: JSON?) throws -> JSON
}

struct CustomExpression: Expression {
    let json: JSON
    let expression: (JSON?) -> JSON

    func evalWithData(_ data: JSON?) throws -> JSON {
        return expression(data)
    }
}

struct SingleValueExpression: Expression {
    let json: JSON

    func evalWithData(_ data: JSON?) throws -> JSON {
        return json
    }
}

struct ArrayOfExpressions: Expression {
    let expressions: [Expression]

    func evalWithData(_ data: JSON?) throws -> JSON {
        return JSON.Array(try expressions.map({ try $0.evalWithData(data) }))
    }
}

struct StrictEquals: Expression {
    let lhs: Expression
    let rhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let lhsBool = try lhs.evalWithData(data)
        let rhsBool = try rhs.evalWithData(data)

        return JSON.Bool(lhsBool == rhsBool)
    }
}

struct Equals: Expression {
    let lhs: Expression
    let rhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        switch (try lhs.evalWithData(data).toNumber(), try rhs.evalWithData(data).toNumber()) {
        case let(JSON.Number(lhsNumber), JSON.Number(rhsBool)):
            return JSON.Bool(lhsNumber == rhsBool)
        default:
            return JSON.Null
        }
    }
}

struct Add: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        var sum = 0.0
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array):
            sum = array.reduce(0.0) { $0 + ($1.toNumber().number!) }
        case let .Number(number):
            sum = number
        case .String:
            sum = result.toNumber().number!
        default:
            return JSON.Null
        }
        return JSON.Number( sum)
    }
}

struct Substruct: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        var sum = 0.0
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            sum = array[0].toNumber().number! - array[1].toNumber().number!
        case let .Array(array) where array.count == 1:
            sum = -array[0].toNumber().number!
        case let .Number(number):
            sum = -number
        case .String:
            sum = -result.toNumber().number!
        default:
            return JSON.Null
        }
        return JSON.Number( sum)
    }
}

struct Multiply: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        var sum = 1.0
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array):
            sum = array.reduce(1.0) { $0 * ($1.toNumber().number!) }
        case let .Number(number):
            sum = number
        case .String:
            sum = result.toNumber().number!
        default:
            return JSON.Null
        }
        return JSON.Number( sum)
    }
}

struct Divide: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        var sum = 0.0
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            sum = array[0].toNumber().number! / array[1].toNumber().number!
        default:
            return JSON.Null
        }
        return JSON.Number( sum)
    }
}

struct Modulo: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            if let a = array[0].toNumber().number,
                  let b = array[1].toNumber().number {
                return JSON.Number(a.truncatingRemainder(dividingBy: b))
            }
            fallthrough
        default:
            return JSON.Null
        }
    }
}

struct Comparison: Expression {
    let arg: Expression
    let operation: (JSON, JSON) -> Bool

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            if case let JSON.String(first) = array[0],
                case let JSON.String(second) = array[1] {
                return JSON(booleanLiteral: operation(JSON.String(first), JSON.String(second)))
            }
            if case let JSON.Number(first) = array[0].toNumber(),
                case let JSON.Number(second) = array[1].toNumber() {
                return JSON.Bool(operation(JSON.Number(first), JSON.Number(second)))
            } else {
                return JSON(false)
            }
        case let .Array(array) where array.count == 3:
            if let first = array[0].toNumber().number,
                let second = array[1].toNumber().number,
                let third = array[2].toNumber().number {
                return JSON.Bool(operation(JSON.Number(first), JSON.Number(second))
                        && operation(JSON.Number(second), JSON.Number(third)))
            } else {
                return JSON(false)
            }
        default:
            return JSON(false)
        }
    }
}

//swiftlint:disable:next type_name
struct If: Expression {
    let arg: ArrayOfExpressions

    func evalWithData(_ data: JSON?) throws -> JSON {
        return try IfWithExpressions(arg.expressions, andData: data)
    }

    func IfWithExpressions(_ expressions: [Expression], andData data: JSON?) throws -> JSON {
        if expressions.count == 0 {
            return JSON.Null
        } else if expressions.count == 1 {
            return try expressions[0].evalWithData(data)
        } else if try expressions[0].evalWithData(data).thruthy() {
            return try expressions[1].evalWithData(data)
        } else if arg.expressions.count == 3 {
            return try expressions[2].evalWithData(data)
        } else {
            return try IfWithExpressions(Array(expressions.dropFirst(2)), andData: data)
        }
    }
}

struct LogicalAndOr: Expression {
    let isAnd: Bool
    let arg: ArrayOfExpressions

    func evalWithData(_ data: JSON?) throws -> JSON {
        for expression in arg.expressions {
            let data = try expression.evalWithData(data)
            if data.thruthy() == !isAnd {
                return data
            }
        }

        return try arg.expressions.last?.evalWithData(data) ?? JSON.Null
    }
}

struct DoubleNegation: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        return JSON.Bool(try arg.evalWithData(data).thruthy())
    }
}

extension JSON {
    func thruthy() -> Bool {
        switch self {
        case let .Bool(bool):
            return bool
        case let .Number(number):
            return number != 0
        case let .String(string):
            return !string.isEmpty
        case let .Array(array):
            return !array.isEmpty
        case .Object:
            return true
        default:
            return false
        }
    }
}

extension JSON {
    func toInteger() -> Int? {
        switch self {
        case let .Number(number):
            return Int(exactly: number)
        default:
            return nil
        }
    }
}

extension JSON {
    func toNumber() -> JSON {
        switch self {
        case let .Bool(bool):
            return bool ? 1 : 0
        case let .Array(array):
//            return JSON.Null
            return array.isEmpty ? 0 : 1
        case .Null:
            return 0
        case .Number:
            return self
        case let .String(string):
            guard let number = Double(string) else {
                return JSON.Null
            }
            return JSON(number)
        default:
            return JSON.Null
        }
    }
}

extension JSON {
    func toJsonLogicString() -> String {
        switch self {
        case let .Bool(bool):
            return "\(bool)"
        case let .Number(number):
            if let intNumber = Int(exactly: number) {
                return "\(intNumber)"
            }
            return "\(number)"
        case let .String(string):
            return string
        case let .Array(array):
            return array.map({$0.toJsonLogicString()}).joined(separator: ",")
        case .Object:
            return ""
        default:
            return ""
        }
    }
}

extension JSON: Comparable {
    public static func < (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case let (.Number(lhsNumber), .Number(rhsNumber)):
            return lhsNumber < rhsNumber
        case let (.String(lhsString), .String(rhsString)):
            return lhsString < rhsString
        default:
            return false
        }
    }

    public static func > (lhs: JSON, rhs: JSON) -> Bool {
        return !(lhs < rhs) && (lhs != rhs)
    }
}

struct Not: Expression {
    let lhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let lhsBool = try lhs.evalWithData(data)

        return JSON.Bool(!lhsBool.thruthy())
    }
}

struct Max: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard case let JSON.Array(array) = try arg.evalWithData(data) else {
            return JSON.Null
        }

        return array.max() ?? JSON.Null
    }
}

struct Min: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard case let JSON.Array(array) = try arg.evalWithData(data) else {
            return JSON.Null
        }

        return array.min() ?? JSON.Null
    }
}

struct Substr: Expression {
    let stringExpression: Expression
    let startExpression: Expression
    let lengthExpression: Expression?

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let str = try stringExpression.evalWithData(data).string,
            let startDouble = try startExpression.evalWithData(data).number,
            let start = Int(exactly: startDouble)
            else {
                return JSON.Null
        }
        let startIndex = str.index(start >= 0 ? str.startIndex : str.endIndex, offsetBy: start)

        if lengthExpression != nil {
            if let lengthDouble = try lengthExpression?.evalWithData(data).number,
                let length = Int(exactly: lengthDouble) {
                let endIndex = str.index(length >= 0 ? startIndex : str.endIndex, offsetBy: length)
                return JSON.String(String(str[startIndex..<endIndex]))
            } else {
                return JSON.Null
            }
        } else {
            return JSON.String(String(str[startIndex..<str.endIndex]))
        }
    }
}

//swiftlint:disable:next type_name
struct In: Expression {
    let stringExpression: Expression
    let collectionExpression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let stringToFind = try stringExpression.evalWithData(data).string
            else {
                return JSON.Null
        }
        if let stringToSearchIn = try collectionExpression.evalWithData(data).string {
            return JSON(stringToSearchIn.contains(stringToFind))
        } else if let arrayToSearchIn = try collectionExpression.evalWithData(data).array {
            return JSON(arrayToSearchIn.contains(JSON(stringToFind)))
        }
        return JSON.Null
    }
}

struct Cat: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        var result = ""

        let evaluation = try arg.evalWithData(data)
        switch evaluation {
        case let JSON.Array(array):
            result = array.reduce(into: "") { (result, element) in
                result.append(element.toJsonLogicString())
            }
        default:
            result = evaluation.toJsonLogicString()
        }

        return JSON(result)
    }
}

struct Var: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let data = data else {
            return JSON.Null
        }

        let variablePath = try evaluateVarPathFromData(data)
        if let variablePathParts = variablePath?.split(separator: ".").map({String($0)}) {
            var partialResult: JSON? = data
            for key in variablePathParts {
                partialResult = partialResult?[key]
            }
            return partialResult ?? JSON.Null
        }

        return JSON.Null
    }

    func evaluateVarPathFromData(_ data: JSON) throws -> String? {
        let variablePathAsJSON = try self.expression.evalWithData(data)

        switch variablePathAsJSON {
        case let .String(string):
            return string
        case let .Array(array):
            return array.first?.string
        default:
            return nil
        }
    }
}

struct Missing: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let keys = try evaluateVarPathFromData(data)

        let missingKeys = keys.filter({ valueForKey($0, in: data) == JSON.Null })
        return JSON.Array(missingKeys.map {JSON.String($0)})
    }

    func valueForKey(_ key: String, in data: JSON?) -> JSON? {
        let variablePathParts = key.split(separator: ".").map({String($0)})
        var partialResult: JSON? = data
        for key in variablePathParts {
            partialResult = partialResult?[key]
        }

        guard let result = partialResult else {
            return JSON.Null
        }

        if case JSON.Error(_) = result {
            return JSON.Null
        }

        return result
    }

    func evaluateVarPathFromData(_ data: JSON?) throws -> [String] {
        let variablePathAsJSON = try self.expression.evalWithData(data)

        switch variablePathAsJSON {
        case let .String(string):
            return [string]
        case let .Array(array):
            return array.compactMap { $0.string }
        default:
            return []
        }
    }
}

struct MissingSome: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let arg = try expression.evalWithData(data)

        guard case let JSON.Array(array) = arg,
              array.count >= 2,
              let minMissing = array[0].toInteger(),
              case let JSON.Array(keys) = array[1] else {
            return JSON.Null
        }

        let missingKeys = keys.filter({ valueForKey($0.string, in: data) == JSON.Null })
        return JSON.Array(missingKeys.count > minMissing ? missingKeys : [])
    }

    func valueForKey(_ key: String?, in data: JSON?) -> JSON? {
        guard let key = key else { return JSON.Null }
        let variablePathParts = key.split(separator: ".").map({ String($0) })
        var partialResult: JSON? = data
        for key in variablePathParts {
            partialResult = partialResult?[key]
        }

        guard let result = partialResult else {
            return JSON.Null
        }

        if case JSON.Error(_) = result {
            return JSON.Null
        }

        return result
    }
}

class Parser {
    private let json: JSON

    init(json: JSON) {
        self.json = json
    }

    func parse() throws -> Expression {
        return try self.parse(json: self.json)
    }

    func parse(json: JSON) throws -> Expression {
        switch json {
        case .Error:
            throw ParseError.GenericError("Error parsing json '\(json)'")
        case .Null:
            return SingleValueExpression(json: json)
        case .Bool:
            return SingleValueExpression(json: json)
        case .Number:
            return SingleValueExpression(json: json)
        case .String:
            return SingleValueExpression(json: json)
        case let .Array(array):
            var arrayOfExpressions: [Expression] = []
            for element in array {
                arrayOfExpressions.append(try parse(json: element))
            }
            return ArrayOfExpressions(expressions: arrayOfExpressions)
        case let .Object(object):
            var arrayOfExpressions: [Expression] = []
            for (key, value) in object {
                arrayOfExpressions.append(try parseExpressionWithKeyword(key, value: value))
            }
            //use only the first for now, we should warn or throw error here if array count > 1
            return arrayOfExpressions.first!
        }
    }

    //swiftlint:disable:next function_body_length cyclomatic_complexity
    func parseExpressionWithKeyword(_ key: String, value: JSON) throws -> Expression {
        switch key {
        case "var":
            return Var(expression: try self.parse(json: value))
        case "===":
            return StrictEquals(lhs: try self.parse(json: value[0]),
                                rhs: try self.parse(json: value[1]))
        case "!==":
            return Not(lhs: StrictEquals(lhs: try parse(json: value[0]),
                                         rhs: try parse(json: value[1])))
        case "==":
            return Equals(lhs: try self.parse(json: value[0]),
                          rhs: try self.parse(json: value[1]))
        case "!=":
            return Not(lhs: Equals(lhs: try self.parse(json: value[0]),
                                   rhs: try self.parse(json: value[1])))
        case "!":
            return Not(lhs: try self.parse(json: value))
        case "+":
            return Add(arg: try self.parse(json: value))
        case "-":
            return Substruct(arg: try self.parse(json: value))
        case "*":
            return Multiply(arg: try self.parse(json: value))
        case "/":
            return Divide(arg: try self.parse(json: value))
        case "%":
            return Modulo(arg: try self.parse(json: value))
        case ">":
            return Comparison(arg: try self.parse(json: value), operation: >)
        case "<":
            return Comparison(arg: try self.parse(json: value), operation: <)
        case ">=":
            return Comparison(arg: try self.parse(json: value), operation: >=)
        case "<=":
            return Comparison(arg: try self.parse(json: value), operation: <=)
        case "if", "?:":
            guard let array = try self.parse(json: value) as? ArrayOfExpressions else {
                throw ParseError.GenericError("\(key) statement be followed by an array")
            }
            return If(arg: array)
        case "and", "or":
            guard let array = try self.parse(json: value) as? ArrayOfExpressions else {
                throw ParseError.GenericError("\(key) statement be followed by an array")
            }
            return LogicalAndOr(isAnd: key=="and", arg: array)
        case "!!":
            return DoubleNegation(arg: try self.parse(json: value[0]))
        case "max":
             return Max(arg: try self.parse(json: value))
        case "min":
            return Min(arg: try self.parse(json: value))
        case "substr":
            guard let array = try self.parse(json: value) as? ArrayOfExpressions else {
                throw ParseError.GenericError("\(key) statement be followed by an array")
            }
            if array.expressions.count == 3 {
                return Substr(stringExpression: array.expressions[0],
                               startExpression: array.expressions[1],
                              lengthExpression: array.expressions[2])
            }
            return Substr(stringExpression: array.expressions[0],
                           startExpression: array.expressions[1],
                          lengthExpression: nil)
        case "in":
            return In(stringExpression: try self.parse(json: value[0]),
                  collectionExpression: try self.parse(json: value[1]))
        case "cat":
            return Cat(arg: try self.parse(json: value))
        case "missing":
            return Missing(expression: try self.parse(json: value))
        case "missing_some":
            return MissingSome(expression: try self.parse(json: value))
        default:
            throw ParseError.UnimplementedExpressionFor(key)
        }
    }
}
