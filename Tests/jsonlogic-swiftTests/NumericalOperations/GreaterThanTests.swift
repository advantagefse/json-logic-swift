//
//  GreaterThanTests.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

class GreaterThanTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testGreaterThan_withNumberConstants() {
        var rule =
                """
                { ">" : [3, 1] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : [1, 1] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : [1, 3] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testGreaterThan_withNonNumbericConstants() {
        var rule =
                """
                { ">" : ["2", "1111"] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : [null, null] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : [null, []] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : ["1", ""] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testGreaterThan_withMixedArguments() {
        var rule =
                """
                { ">" : ["2", 1111] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : ["2222", 1111] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : ["b", 1111] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : [1, null] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                 { ">" : [1, []] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { ">" : [[[]], 0] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testGreaterThan_withVariables() {
        let data =
                """
                    { "a" : "b", "b" : "1", "oneNest" : {"one" : true} }
                """

        var rule =
                """
                { ">" : [3, {"var" : ["oneNest.one"]}] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                 { ">" : [1, {"var" : ["a"] }] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                { ">" : [1, ["nonExistant"]] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                { ">" : [2, ["b"]] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))
    }

    static var allTests = [
        ("testGreaterThan_withNumberConstants", testGreaterThan_withNumberConstants),
        ("testGreaterThan_withNonNumbericConstants", testGreaterThan_withNonNumbericConstants),
        ("testGreaterThan_withMixedArguments", testGreaterThan_withMixedArguments),
        ("testGreaterThan_withVariables", testGreaterThan_withVariables)
    ]
}
