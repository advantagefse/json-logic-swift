//
//  Parser.swift
//  jsonlogic-swift
//
//  Created by Christos Koninis on 16/06/2018.
//

import Foundation
import JSON
import os.log

struct Log {
//    static var general = OSLog(subsystem: "swiftlogic", category: "general")

//    static func log(message: StaticString, type: OSLogType = .debug) -> Void {
//        os_log(message, log: Log.general, type: type)
//    }

//    static func log(message: StaticString, args: CVarArg, type: OSLogType = .debug) -> Void {
//        os_log(message, log: Log.general, type: type, args)
//    }
}

//BNF
// var_expression -> var_keyword array_single_string | var_keyword single_string

// strict_equals_expression -> strict_equals_operator arrayOfValueOrExpressionValueOrExpression
// arrayOfValueOrExpressionValueOrExpression -> valueOrExpression valueOrExpression
// valueOrExpression -> value | expression
// expression -> var_expression | strict_equals_expression
// value -> single_integer | single_string | single_boolean

enum ParseError: Error {
    case UnexpectedToken(expectedToken: Token?, foundToken: Token?)
    case UnimplementedExpressionWith(operator: Token?)
    case GenericError(String)
}

protocol Expression {
    func evalWithData(_ data: JSON?) throws -> JSON
}

enum EvaluationError: Error {
    case variableNotFound(String)
    case canNotEvaluateExpressionWithNoData(expression: Expression)
    case varExpressionNeedsAsStringParameter(insteadFound: JSON)
}

struct AnyExpression<ResultType> {
    let _evalWithData: (JSON?) throws -> ResultType

//    func evalWithData(_ data: JSON?) throws -> ResultType {
//        return try self._evalWithData(data)
//    }

    //    init<E: Expression>(xpr: E) where E.ResultType == ResultType {
    //        self.evalWithData = xpr.evalWithData
    //    }
}

extension AnyExpression: Expression where ResultType == JSON {

    func evalWithData(_ data: JSON?) throws -> ResultType {
        return try self._evalWithData(data)
    }

    init(_ value: JSON) {
        self._evalWithData = { (_) -> ResultType in
            return value
        }
    }

    init(_ expression: Expression) {
        _evalWithData = expression.evalWithData
    }

    //    init<E: Expression>(xpr: E) where E.ResultType == ResultType {
    //        self.evalWithData = xpr.evalWithData
    //    }
}

struct Strict_equals_expression: Expression {
    let lhs: AnyExpression<JSON>
    let rhs: AnyExpression<JSON>

    func evalWithData(_ data: JSON?) throws -> JSON {
        let lhsBool = try lhs.evalWithData(data)
        let rhsBool = try rhs.evalWithData(data)

        return JSON(booleanLiteral: lhsBool == rhsBool)
    }
}

struct VarExpression: Expression {

    func evalWithData(_ data: JSON?) throws -> JSON {

        guard let data = data else {
            throw EvaluationError.canNotEvaluateExpressionWithNoData(expression: self)
        }

        let variablePathAsJSON = try self.variablePathExpression.evalWithData(data)
        guard let variablePath = variablePathAsJSON.string else {
            throw EvaluationError.varExpressionNeedsAsStringParameter(insteadFound: variablePathAsJSON)
        }

        let variablePathParts = variablePath.split(separator: ".").map({String($0)})

        var partialResult: JSON? = data
        for key in variablePathParts {
            if key == variablePathParts.last {
//                Log.log(message: "key is %@", args: key)
//                let lala = partialResult?[key]
                if let result = partialResult?[key] {
                    return result
                }
            }
            else {
                partialResult = partialResult?[key]
            }
        }

        throw EvaluationError.variableNotFound(variablePath)
    }

    init(variablePathInDataJson: String) {
        self.variablePath = variablePathInDataJson
        self.variablePathParts = variablePathInDataJson.split(separator: ".").map({String($0)})
        self.variablePathExpression = AnyExpression(JSON(variablePathInDataJson))
    }

    init(_ expression: AnyExpression<JSON>) {
        self.variablePathExpression = expression
        variablePath = nil
        variablePathParts = nil
    }

    let variablePathExpression: AnyExpression<JSON>
    private var variablePath: String?
    private let variablePathParts: [String]?
}

class Parser {
    //    private let json: JSON
    private let tokens: [Token]
    private let totalTokens: Int
    private var index = -1

    init(tokens: [Token]) {
        self.tokens = tokens
        self.totalTokens = tokens.count
    }

    var tokensAvailable: Bool {
        return index + 1 < totalTokens
    }

    func popNextToken() -> Token? {
        guard tokensAvailable else {
            return nil
        }

        index += 1
        let nextToken = tokens[index]
        return nextToken
    }

    func peakNextToken() -> Token? {
        guard tokensAvailable else {
            return nil
        }

        let nextToken = tokens[index + 1]
        return nextToken
    }

    func peakPreviousToken() -> Token? {
        if index - 1 > 0 {
            return tokens[index - 1]
        }
        
        return nil
    }

    func tryTo(_ parser: () throws -> Expression ) throws -> Expression {
        let savedIndex = index
        do {
            return try parseExpression()
        }
        catch let error {
            index = savedIndex
            throw error
        }
    }

    func parseExpression() throws -> Expression {
//        Log.log(message: "parsing var expression")
            guard let nextToken = popNextToken() else {
                throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
            }

            switch nextToken {
            case let Token.var_operator(token):
                return VarExpression(AnyExpression(try Parser(tokens: [token]).parseExpression()))
            case let Token.var_operator_array(array):
                return VarExpression(AnyExpression(try Parser(tokens: array).parseExpression()))
            case let Token.strict_equals_operator(a, b):
                return Strict_equals_expression(lhs: AnyExpression(try Parser(tokens: [a]).parseExpression()), rhs: AnyExpression(try Parser(tokens: [b]).parseExpression()))
            case let Token.single_double(value):
                return AnyExpression(JSON(value))
            case let Token.single_integer(value):
                return AnyExpression(JSON(value))
            case let Token.single_string(value):
                return AnyExpression(JSON(value))
            case let Token.single_boolean(value):
                return AnyExpression(JSON(value))
            default:
                throw ParseError.UnimplementedExpressionWith(operator: nextToken)
            }
    }

    // strict_equals_expression -> strict_equals_operator arrayOfValueOrExpressionValueOrExpression
    // arrayOfValueOrExpressionValueOrExpression -> valueOrExpression valueOrExpression
    // valueOrExpression -> value | expression
    // expression -> var_expression | strict_equals_expression
    // value -> single_integer | single_string | single_boolean | single_double //This should be same value objects

    func parseStrict_equals_expression() throws -> Strict_equals_expression {
        guard let nextToken = popNextToken() else {
            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
        }

        switch nextToken {
        case let Token.array_of_tokens(array):
            if array.count != 2 {
                throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
            }

            return Strict_equals_expression(lhs: AnyExpression(try Parser(tokens: [array[0]]).parseExpression()), rhs: AnyExpression(try Parser(tokens: [array[1]]).parseExpression()))
//        case let Token.array_single_string(pathArray):
//            return Strict_equals_expression(lhs: AnyExpression(JSON(pathArray[0])), rhs: AnyExpression(JSON(pathArray[1])))
//        case let Token.array_single_int(pathArray):
//            return Strict_equals_expression(lhs: AnyExpression(JSON(pathArray[0])), rhs: AnyExpression(JSON(pathArray[1])))
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }

//    func parseValueOrExpression() throws -> Expression {
//        guard let nextToken = popNextToken() else {
//            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
//        }
//
//        switch nextToken {
//        case let Token.array_single_string(pathArray):
//            return Strict_equals_expression(lhs: AnyExpression(JSON(pathArray[0])), rhs: AnyExpression(JSON(pathArray[1])))
//        case let Token.array_single_int(pathArray):
//            return Strict_equals_expression(lhs: AnyExpression(JSON(pathArray[0])), rhs: AnyExpression(JSON(pathArray[1])))
//        default:
//            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
//        }
//    }

    func parseSingleIntegerOrBoolOrDoubleOrString() throws -> Expression {
        guard let nextToken = popNextToken() else {
            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
        }

        switch nextToken {
        case let Token.single_double(value):
            return AnyExpression(JSON(value))
        case let Token.single_integer(value):
            return AnyExpression(JSON(value))
        case let Token.single_string(value):
            return AnyExpression(JSON(value))
        case let Token.single_boolean(value):
            return AnyExpression(JSON(value))
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }

    func parseSingleDouble() throws -> Expression {
        guard let nextToken = popNextToken() else {
            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
        }

        switch nextToken {
        case let Token.single_double(value):
            return AnyExpression(JSON(value))
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }

    func parseSingleInteger() throws -> Expression {
        guard let nextToken = popNextToken() else {
            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
        }

        switch nextToken {
        case let Token.single_integer(value):
            return AnyExpression(JSON(value))
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }

    func parseSingleString() throws -> Expression {
        guard let nextToken = popNextToken() else {
            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
        }

        switch nextToken {
        case let Token.single_string(value):
            return AnyExpression(JSON(value))
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }

    func parseSingleBool() throws -> Expression {
        guard let nextToken = popNextToken() else {
            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
        }

        switch nextToken {
        case let Token.single_boolean(value):
            return AnyExpression(JSON(value))
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }

    func parseVar_expression() throws -> VarExpression {

        guard let nextToken = popNextToken() else {
            throw parseErrorWhenParsingToken(nil, expected: Token.single_string(""))
        }

        switch nextToken {
        case let Token.single_string(path):
            return VarExpression(variablePathInDataJson: path)
        case let Token.array_of_tokens(array):
            guard array.count == 1,
                let tokenString = array.first,
                case let Token.single_string(string) = tokenString else {
                throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
            }
            return VarExpression(variablePathInDataJson: string)
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }

    func parseErrorWhenParsingToken(_ token: Token?, expected expectedToken: Token?) -> ParseError {
        return ParseError.UnexpectedToken(expectedToken: expectedToken, foundToken: token)
    }
}
