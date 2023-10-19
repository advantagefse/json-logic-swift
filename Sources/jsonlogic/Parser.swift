//
//  Parser.swift
//  jsonlogic
//
//  Created by Christos Koninis on 16/06/2018.
//  Licensed under MIT
//

import Foundation
import JSON

public enum ParseError: Error, Equatable {
    case UnimplementedExpressionFor(_ operator: String)
    case GenericError(String)
}

protocol Expression {
    func evalWithData(_ data: JSON?) throws -> JSON
}

struct CustomExpression: Expression {
    let expression: Expression
    let customOperator: (JSON?) -> JSON

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)
        return customOperator(result)
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
        return JSON.Bool((try lhs.evalWithData(data)) === (try rhs.evalWithData(data)))
    }
}

struct Equals: Expression {
    let lhs: Expression
    let rhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        return JSON.Bool((try lhs.evalWithData(data)) == (try rhs.evalWithData(data)))
    }
}

struct Add: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let sum = JSON(0)
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array):
            return array.reduce(sum) { $0 + ($1.toNumber()) }
        default:
            return result.toNumber()
        }
    }
}

struct Subtract: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            return array[0].toNumber() - array[1].toNumber()
        case let .Array(array) where array.count == 1:
            return -array[0].toNumber()
        default:
            return -result.toNumber()
        }
    }
}

struct Multiply: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let total = JSON(1)
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array):
            return array.reduce(total) { $0 * ($1.toNumber()) }
        default:
            return result.toNumber()
        }
    }
}

struct Divide: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            return array[0].toNumber() / array[1].toNumber()
        default:
            return JSON.Null
        }
    }
}

struct Modulo: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            return array[0] % array[1]
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
            if case JSON.String(_) = array[0],
                case JSON.String(_) = array[1] {
                return JSON(booleanLiteral: operation(array[0], array[1]))
            }
            let lala = operation(array[0], array[1])
            let papa = JSON.Bool(lala)
            return papa
        case let .Array(array) where array.count == 3:
            return JSON.Bool(operation(array[0], array[1])
                                     && operation(array[1], array[2]))
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
        if expressions.isEmpty {
            return JSON.Null
        } else if expressions.count == 1 {
            return try expressions[0].evalWithData(data)
        } else if try expressions[0].evalWithData(data).truthy() {
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
            if data.truthy() == !isAnd {
                return data
            }
        }

        return try arg.expressions.last?.evalWithData(data) ?? JSON.Null
    }
}

struct DoubleNegation: Expression {
    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let data = try arg.evalWithData(data)
        guard case let JSON.Array(array) = data else {
            return JSON.Bool(data.truthy())
        }
        if let firstItem = array.first {
            return JSON.Bool(firstItem.truthy())
        }
        return JSON.Bool(false)
    }
}

struct Not: Expression {
    let lhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let lhsBool = try lhs.evalWithData(data)

        guard case let JSON.Array(array) = lhsBool else {
            return JSON.Bool(!lhsBool.truthy())
        }
        if let firstItem = array.first {
            return JSON.Bool(!firstItem.truthy())
        }

        return JSON.Bool(true)
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
              case let .Int(start) = try startExpression.evalWithData(data)
            else {
                return JSON.Null
        }
        let startIndex = str.index(start >= 0 ? str.startIndex : str.endIndex,
                                    offsetBy: Int(start))

        if lengthExpression != nil {
            if case let .Int(length)? = try lengthExpression?.evalWithData(data) {
                let endIndex = str.index(length >= 0 ? startIndex : str.endIndex,
                                         offsetBy: Int(length))
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
    let targetExpression: Expression
    let collectionExpression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        if let stringToFind = try targetExpression.evalWithData(data).string,
            let stringToSearchIn = try collectionExpression.evalWithData(data).string {
            return JSON(stringToSearchIn.contains(stringToFind))
        } else if let arrayToSearchIn = try collectionExpression.evalWithData(data).array {
            if let stringToFind = try targetExpression.evalWithData(data).string {
                return JSON(arrayToSearchIn.contains(JSON(stringToFind)))
            } else if let integerToFind = try targetExpression.evalWithData(data).int {
                return JSON(arrayToSearchIn.contains(JSON(integerToFind)))
            } else if let doubleToFind = try targetExpression.evalWithData(data).double {
                return JSON(arrayToSearchIn.contains(JSON(doubleToFind)))
            } else if let boolToFind = try targetExpression.evalWithData(data).bool {
                return JSON(arrayToSearchIn.contains(JSON(boolToFind)))
            }
        }
        return JSON.Bool(false)
    }
}

struct Cat: Expression {
    let arg: Expression

    private func stringFromJSON(_ json: JSON) -> String {
        switch json {
        case let .Bool(bool):
            return "\(bool)"
        case let .Double(number):
            return "\(number)"
        case let .Int(number):
            return "\(number)"
        case let .String(string):
            return string
        case let .Array(array):
            return array.map({stringFromJSON($0)}).joined(separator: ",")
        case .Dictionary:
            return ""
        default:
            return ""
        }
    }

func evalWithData(_ data: JSON?) throws -> JSON {
        var result = ""

        let evaluation = try arg.evalWithData(data)
        switch evaluation {
        case let JSON.Array(array):
            result = array.reduce(into: "") { (result, element) in
                result.append(stringFromJSON(element))
            }
        default:
            result = stringFromJSON(evaluation)
        }

        return JSON(result)
    }
}

struct Var: Expression {
    let expression: Expression
    let defaultArgument: JSON

    internal init(expression: Expression, defaultArgument: JSON = JSON.Null) {
        self.expression = expression
        self.defaultArgument = defaultArgument
    }

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let data = data else {
            return defaultArgument
        }

      let variablePath = try evaluateVarPathFromData(data)
      if let variablePathParts = variablePath?.split(separator: ".").map({String($0)}) {
          var partialResult: JSON? = data
          for key in variablePathParts {
              if partialResult?.type == .array {
                if let index = Int(key), let maxElement = partialResult?.array?.count,  index < maxElement, index >= 0  {
                  partialResult = partialResult?[index]
                } else {
                  partialResult = partialResult?[key]
                }
              } else {
                partialResult = partialResult?[key]
              }
          }

          guard let partialResult = partialResult else {
              return defaultArgument
          }

          if case JSON.Error(_) = partialResult {
              return defaultArgument
          }

          return partialResult
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
              case let .Int(minRequired) = array[0],
              case let JSON.Array(keys) = array[1] else {
            return JSON.Null
        }

        let foundKeys = keys.filter({ valueForKey($0.string, in: data) != JSON.Null })
        let missingkeys = { keys.filter({ !foundKeys.contains($0) }) }

        return JSON.Array(foundKeys.count < minRequired ? missingkeys() : [])
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

struct ArrayMap: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
        case let JSON.Array(dataArray) = try array.expressions[0].evalWithData(data)
                else {
                return JSON(string: "[]")!
        }

        let mapOperation = array.expressions[1]

        let result = try dataArray.map { json -> JSON in try mapOperation.evalWithData(json) }
        return JSON.Array(result)
    }
}

struct ArrayReduce: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 3,
              let intoValue: JSON = try? array.expressions[2].evalWithData(data)
                else {
            return JSON.Null
        }
        guard case let JSON.Array(dataArray) = try array.expressions[0].evalWithData(data) else {
            return intoValue
        }

        let reduceOperation = array.expressions[1]

        return try dataArray.reduce(into: intoValue) { (result: inout JSON, value: JSON) in
            let reduceContext = JSON(["accumulator": result, "current": value])
            result = try reduceOperation.evalWithData(reduceContext)
        }
    }
}

struct ArrayFilter: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let JSON.Array(dataArray) = try array.expressions[0].evalWithData(data)
            else {
                return JSON.Array([])
        }

        let filterOperation = array.expressions[1]

        return JSON.Array(try dataArray.filter({ try filterOperation.evalWithData($0).truthy() }))
    }
}

struct ArrayNone: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let JSON.Array(dataArray) = try array.expressions[0].evalWithData(data)
            else {
                return JSON.Null
        }
        let operation = array.expressions[1]

        return JSON.Bool(try dataArray.reduce(into: true) {
            $0 = try $0 && !operation.evalWithData($1).truthy()
        })
    }
}

struct ArrayAll: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 2,
              case let JSON.Array(dataArray) = try array.expressions[0].evalWithData(data)
                else {
            return JSON.Null
        }

        let operation = array.expressions[1]

        return JSON.Bool(try dataArray.reduce(into: !dataArray.isEmpty) {
            $0 = try $0 && operation.evalWithData($1).truthy()
        })
    }
}

struct ArraySome: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 2,
              case let JSON.Array(dataArray) = try array.expressions[0].evalWithData(data)
                else {
            return JSON.Null
        }

        let operation = array.expressions[1]

        return JSON.Bool(try dataArray.reduce(into: false) {
            $0 = try $0 || operation.evalWithData($1).truthy()
        })
    }
}

struct ArrayMerge: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let dataArray = try expression.evalWithData(data)

        return JSON.Array(recursiveFlattenArray(dataArray))
    }

    func recursiveFlattenArray(_ json: JSON) -> [JSON] {
        switch json {
        case let .Array(array):
            return array.flatMap({ recursiveFlattenArray($0) })
        default:
            return [json]
        }
    }
}

struct Log: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)
        print("\(String(describing: try result.convertToSwiftTypes()))")
        return result
    }
}

class Parser {
    private let json: JSON
    private let customOperators: [String: (JSON?) -> JSON]

    init(json: JSON, customOperators: [String: (JSON?) -> JSON]?) {
        self.json = json
        self.customOperators = customOperators ?? [:]
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
        case .Int:
            return SingleValueExpression(json: json)
        case .Double:
            return SingleValueExpression(json: json)
        case .String:
            return SingleValueExpression(json: json)
        case let .Array(array):
            var arrayOfExpressions: [Expression] = []
            for element in array {
                arrayOfExpressions.append(try parse(json: element))
            }
            return ArrayOfExpressions(expressions: arrayOfExpressions)
        case let .Dictionary(object):
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
            guard let array = try self.parse(json: value) as? ArrayOfExpressions,
                  array.expressions.count >= 2,
                  let defaultArgument = array.expressions[1] as? SingleValueExpression else {
                      return Var(expression: try self.parse(json: value))
                  }
            return Var(expression: array.expressions[0], defaultArgument: try defaultArgument.evalWithData(nil))
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
            return Subtract(arg: try self.parse(json: value))
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
            return LogicalAndOr(isAnd: key == "and", arg: array)
        case "!!":
            return DoubleNegation(arg: try self.parse(json: value))
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
            return In(targetExpression: try self.parse(json: value[0]),
                  collectionExpression: try self.parse(json: value[1]))
        case "cat":
            return Cat(arg: try self.parse(json: value))
        case "missing":
            return Missing(expression: try self.parse(json: value))
        case "missing_some":
            return MissingSome(expression: try self.parse(json: value))
        case "map":
            return ArrayMap(expression: try self.parse(json: value))
        case "reduce":
            return ArrayReduce(expression: try self.parse(json: value))
        case "filter":
            return ArrayFilter(expression: try self.parse(json: value))
        case "none":
            return ArrayNone(expression: try self.parse(json: value))
        case "all":
            return ArrayAll(expression: try self.parse(json: value))
        case "some":
            return ArraySome(expression: try self.parse(json: value))
        case "merge":
            return ArrayMerge(expression: try self.parse(json: value))
        case "log":
            return Log(expression: try self.parse(json: value))
        default:
            if let customOperation = self.customOperators[key] {
                return CustomExpression(expression: try self.parse(json: value),
                                    customOperator: customOperation)
            } else {
                throw ParseError.UnimplementedExpressionFor(key)
            }
        }
    }
}
