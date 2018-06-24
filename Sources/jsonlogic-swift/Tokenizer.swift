//
//  Tokenizer.swift
//  jsonlogic
//
//  Created by Christos Koninis on 24/06/2018.
//

import Foundation

enum TokenizerError: Error {
    case JSONObjectExpected
    case UnExpectedToken(Any)
}

enum Token {
    case var_keyword
    case array_single_string([String])
    case single_string(String)
}

open class Tokenizer {
    let jsonString: String
    let jsonDictionary: [String: Any]
    var tokens: [Token] = []

    init?(jsonString: String) throws {
        self.jsonString = jsonString

        let jsonData = jsonString.data(using: String.Encoding.utf8)
        jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: Any]

        _ = try tokenize(jsonDictionary: jsonDictionary)
    }

    func tokenize(jsonDictionary:  [String: Any]) throws -> [Token] {
        for (key, value) in jsonDictionary {
            if key == "var" {
                tokens.append(.var_keyword)
                if let varString = value as? String {
                    tokens.append(Token.single_string(varString))
                }
                else {
                    throw TokenizerError.UnExpectedToken(value)
                }
                //                else if let varString: String = value as? String else {
                //                    throw TokenizerError.UnExpectedToken(value)
                //                }
                //                else {
                //
                //                }

            }
            //            tokenize(jsonDictionary: value)
        }

        return tokens
    }
}
