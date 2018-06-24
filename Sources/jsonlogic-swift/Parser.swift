//
//  Parser.swift
//  jsonlogic-swift
//
//  Created by Christos Koninis on 16/06/2018.
//

import Foundation

enum ParseError: Error {
    case UnexpectedToken(expectedToken: Token, foundToken: Token?)
    case GenericError(String)
}

protocol Expression {
    func evalWithData<T: Value>(_ data: [String: Any]?) throws -> T?
}

enum EvaluationError: Error {
    case variableNotFound(String)
}

struct VarExpression: Expression {

    func evalWithData<T: Value>(_ data: [String : Any]?) throws -> T? {
        guard let data = data else {
            throw EvaluationError.variableNotFound(variablePath)
        }

        print("type is \(T.self)")

        var s = AnyCollection(variablePathParts)
        let lastObject = valueForKeyPath(&s, in: data)

        guard let lastKey = variablePathParts.last, let value = lastObject?[lastKey] as? T  else {
            throw EvaluationError.variableNotFound(variablePath)
        }

        return value
    }

    private func valueForKeyPath(_ keyPath: inout AnyCollection<String>, in jsonDictionary: [String: Any]?) -> [String: Any]? {
        guard let key = keyPath.first, let nextJsonDictionary = jsonDictionary?[key] as? [String: Any] else {
            return jsonDictionary
        }

        return valueForKeyPath(&keyPath, in: nextJsonDictionary)
    }

    init(variablePathInDataJson: String) {
        self.variablePath = variablePathInDataJson
        self.variablePathParts = variablePathInDataJson.split(separator: ".").map({String($0)})
    }

    let variablePath: String
    let variablePathParts: [String]
}

class Parser {
    private let tokens: [Token]
    private let totalTokens: Int
    private var index = 0

    init(tokens: [Token]) {
        self.tokens = tokens
        self.totalTokens = tokens.count
    }

    var tokensAvailable: Bool {
        return index < totalTokens
    }

    func popNextToken() -> Token {
        let nextToken = tokens[index]
        index += 1
        return nextToken
    }

    func peakNextToken() -> Token {
        return tokens[index]
    }

    func peakPreviousToken() -> Token {
        return tokens[index - 1]
    }

    func parse() throws -> Expression {
        return try parseVar_expression()
    }

    func parseVar_expression() throws -> VarExpression {
        guard case Token.var_keyword = popNextToken() else {
            throw ParseError.UnexpectedToken(expectedToken: Token.var_keyword, foundToken: peakPreviousToken())
        }

        let nextToken = popNextToken()
        switch nextToken {
        case let Token.single_string(path):
            return VarExpression(variablePathInDataJson: path)
        case let Token.array_single_string(pathArray):
            return VarExpression(variablePathInDataJson: pathArray[0])
        default:
            throw ParseError.UnexpectedToken(expectedToken: Token.single_string(""), foundToken: nextToken)
        }
    }
}
