//
//  IfTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic

//swiftlint:disable function_body_length
class IfTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testIf_ToofewArgs() {
        var rule =
                """
                { "if":[ [], "apple", "banana"] }
                """
        XCTAssertEqual("banana", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "if":[ [1], "apple", "banana"] }
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "if":[ [1,2,3,4], "apple", "banana"] }
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))
    }

    func testIf_SimpleCases() {
        var rule =
                """
                    {"if":[ {">":[2,1]}, "apple", "banana"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                   {"if":[ {">":[1,2]}, "apple", "banana"]}
                """
        XCTAssertEqual("banana", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("banana", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))
    }

    func testIf_EmptyArraysAreFalsey() {
        var rule =
                """
                { "if" : [] }
                """
        XCTAssertNil(try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "if" : [true] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "if" : [false] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "if" : ["apple"] }
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))
    }

    func testIf_NonEmptyOtherStringsAreTruthy() {
        var rule =
                """
                {"if":[ "", "apple", "banana"]}
                """
        XCTAssertEqual("banana", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[ "zucchini", "apple", "banana"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[ "0", "apple", "banana"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))
    }

    func testIf_IfThenElseIfThenCases() {
        var rule =
                """
                {"if":[true, "apple", true, "banana"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana"]}
                """
        XCTAssertEqual("banana", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana"]}
                """
        XCTAssertNil(try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", "carrot"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("banana", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", "carrot"]}
                """
        XCTAssertEqual("carrot", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", false, "carrot"]}
                """
        XCTAssertNil(try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("date", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("banana", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try jsonLogic.applyRule(rule, to: nil))
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

        XCTAssertEqual("fizzbuzz", try jsonLogic.applyRule(rule, to: "{\"i\" : 0}"))
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: "{\"i\" : 1}"))
        XCTAssertEqual(2, try jsonLogic.applyRule(rule, to: "{\"i\" : 2}"))
        XCTAssertEqual("fizz", try jsonLogic.applyRule(rule, to: "{\"i\" : 3}"))
        XCTAssertEqual("buzz", try jsonLogic.applyRule(rule, to: "{\"i\" : 5}"))
        XCTAssertEqual("fizzbuzz", try jsonLogic.applyRule(rule, to: "{\"i\" : 15}"))
        XCTAssertEqual("fizzbuzz", try jsonLogic.applyRule(rule, to: "{\"i\" : 45}"))
    }

    static var allTests = [
        ("testIf_ToofewArgs", testIf_ToofewArgs),
        ("testIf_SimpleCases", testIf_SimpleCases),
        ("testIf_EmptyArraysAreFalsey", testIf_EmptyArraysAreFalsey),
        ("testIf_NonEmptyOtherStringsAreTruthy", testIf_NonEmptyOtherStringsAreTruthy),
        ("testIf_IfThenElseIfThenCases", testIf_IfThenElseIfThenCases)
    ]
}
