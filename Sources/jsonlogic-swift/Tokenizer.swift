//
//  Tokenizer.swift
//  jsonlogic
//
//  Created by Christos Koninis on 24/06/2018.
//

import Foundation
import JSON

enum TokenizerError: Error {
    case JSONObjectExpected
    case UnExpectedToken(Any)
}

indirect enum Token {
    case var_operator(arg1: Token)
    case var_operator_array(arg1: [Token])
    case strict_equals_operator(arg1: Token, arg2: Token)
    case single_string(String)
    case single_boolean(Bool)
    case single_integer(Int)
    case single_double(Double)
    case array_of_tokens([Token])
    case empty
}

open class Tokenizer {
    let jsonString: String
    let jsonDictionary: [String: Any]
    var tokens: [Token] = []

    init?(jsonString: String) throws {
        self.jsonString = jsonString

        let jsonData = jsonString.data(using: String.Encoding.utf8)
        jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: Any]

        for (key, value) in jsonDictionary {
            tokens.append(try tokenize([key : value]))
        }
    }

    func tokenize(_ json:  [String: Any]) throws -> Token {

        for (key, value) in json {
            if key == "var" {
                if let varString = value as? String {
                    return .var_operator(arg1: Token.single_string(varString))
                }
                else if let array = value as? [Any] {
                    return .var_operator_array(arg1: try tokenize(array))
                }
                else if let object = value as? [String: Any] {
                    return .var_operator(arg1: try tokenize(object))
                }
                else {
                    throw TokenizerError.UnExpectedToken(value)
                }
            }
            else if key == "===" {
                guard let array = value as? [Any] else {
                    throw TokenizerError.UnExpectedToken("")
                }
//                guard let arg1 = array[0] as? [String : Any] else {
//                    throw TokenizerError.UnExpectedToken("")
//                }
//                guard let arg2 = array[1] as? [String : Any] else {
//                    throw TokenizerError.UnExpectedToken("")
//                }

                return .strict_equals_operator(arg1: try tokenize(array[0]), arg2: try tokenize(array[1]))
            }
            else {
                throw TokenizerError.UnExpectedToken(key)
            }
        }

        return Token.empty
    }

    func tokenize(_ json: Any) throws -> Token {
        switch json {
        case let a as Int:
            return tokenize(a)
        case let a as Double:
            return tokenize(a)
        case let a as Bool:
            return tokenize(a)
        case let a as String:
            return tokenize(a)
        case let a as Int:
            return tokenize(a)
        case let a as [Any]:
            return try tokenize(a)
        case let a as [String: Any]:
            return try tokenize(a)
        default:
            throw TokenizerError.UnExpectedToken(json)
        }
    }

    func tokenize(_ json: Int) -> Token {
        return Token.single_integer(json)
    }

    func tokenize(_ json: Double) -> Token {
        return Token.single_double(json)
    }

    func tokenize(_ json: Bool) -> Token {
        return Token.single_boolean(json)
    }

    func tokenize(_ json: String) -> Token {
        return Token.single_string(json)
    }

    func tokenize(_ json: [Any]) throws -> [Token] {
        
        var tokens: [Token] = []

//        if let array = json as? [String] {
//            return [Token.array_single_string(array)]
//        }
//        if let array = json as? [Int] {
//            return [Token.array_single_int(array)]
//        }

        for v in json {
            switch v {
            case let v as Int:
                tokens.append(tokenize(v))
            case let v as Double:
                tokens.append(tokenize(v))
            case let v as Bool:
                tokens.append(tokenize(v))
            case let v as String:
                tokens.append(tokenize(v))
            case let v as [String: Any]:
                try tokens.append(tokenize(v))
            case let v as [Any]:
                try tokens.append(contentsOf: tokenize(v))
            default:
                throw TokenizerError.UnExpectedToken("")
            }
        }

        return tokens
//        return tokens.flatMap({ let s = tokenize(value: $0); return s is Collection ? s : [s] })
    }

}
