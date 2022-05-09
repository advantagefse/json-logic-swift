//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

//swiftlint:disable function_body_length
class IfTests: XCTestCase {

    func testIf_ToofewArgs() {
        var rule =
                """
                { "if":[ [], "apple", "banana"] }
                """
        XCTAssertEqual("banana", try applyRule(rule, to: nil))

        rule =
                """
                { "if":[ [1], "apple", "banana"] }
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                { "if":[ [1,2,3,4], "apple", "banana"] }
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))
    }

    func testIf_SimpleCases() {
        var rule =
                """
                    {"if":[ {">":[2,1]}, "apple", "banana"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                   {"if":[ {">":[1,2]}, "apple", "banana"]}
                """
        XCTAssertEqual("banana", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("banana", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))
    }

    func testIf_EmptyArraysAreFalsey() {
        var rule =
                """
                { "if" : [] }
                """
        XCTAssertNil(try applyRule(rule, to: nil))

        rule =
                """
                { "if" : [true] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "if" : [false] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "if" : ["apple"] }
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))
    }

    func testIf_NonEmptyOtherStringsAreTruthy() {
        var rule =
                """
                {"if":[ "", "apple", "banana"]}
                """
        XCTAssertEqual("banana", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[ "zucchini", "apple", "banana"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[ "0", "apple", "banana"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))
    }

    func testIf_IfThenElseIfThenCases() {
        var rule =
                """
                {"if":[true, "apple", true, "banana"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana"]}
                """
        XCTAssertEqual("banana", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana"]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", "carrot"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("banana", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", "carrot"]}
                """
        XCTAssertEqual("carrot", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", false, "carrot"]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("date", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("banana", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))
    }

    func testIf_FizzBuzz() {
        let rule =
                """
                {
                "if": [
                {"==": [ { "%": [ { "var": "i" }, 15 ] }, 0]},
                "fizzbuzz",

                {"==": [ { "%": [ { "var": "i" }, 3 ] }, 0]},
                "fizz",

                {"==": [ { "%": [ { "var": "i" }, 5 ] }, 0]},
                "buzz",

                { "var": "i" }
                ]
                }
                """

        XCTAssertEqual("fizzbuzz", try applyRule(rule, to: "{\"i\" : 0}"))
        XCTAssertEqual(1, try applyRule(rule, to: "{\"i\" : 1}"))
        XCTAssertEqual(2, try applyRule(rule, to: "{\"i\" : 2}"))
        XCTAssertEqual("fizz", try applyRule(rule, to: "{\"i\" : 3}"))
        XCTAssertEqual("buzz", try applyRule(rule, to: "{\"i\" : 5}"))
        XCTAssertEqual("fizzbuzz", try applyRule(rule, to: "{\"i\" : 15}"))
        XCTAssertEqual("fizzbuzz", try applyRule(rule, to: "{\"i\" : 45}"))
    }
}
