//
//  NotStringEquals.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest

@testable import jsonlogic_swift

class NotStrictEquals: XCTestCase {

    let jsonLogic = JsonLogic()

    func testNot_StrictEquals_withConstants() {
        let rule =
                """
                    { "!==" : [1, 2] }
                """

        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testNot_StrictEquals_withConstants1() {
        let rule =
                """
                    { "!==" : [1, "1"] }
                """

        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testNot_StrictEquals_withConstants2() {
        let rule =
                """
                    { "!==" : [1, 1] }
                """

        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testNot_StrictEquals_withConstants3() {
        let rule =
                """
                    { "!==" : [1, []] }
                """

        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testNotStringEquals_NestedVar() {
        let rule =
                """
                    { "!==" : [ {"var" : [ {"var" : ["a"]} ] }, {"var" : ["oneNest.one"]}] }
                """
        let data =
                """
                    { "a" : "b", "b" : "1", "oneNest" : {"one" : "1"} }
                """

        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))
    }

    func testLogicalNot_withBooleanConstants() {
        var rule =
                """
                    { "!" : [true] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    { "!" : [false] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    {"!" : true}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    {"!" : false}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLogicalNot_withArrays() {
        var rule =
                """
                    {"!" : []}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    {"!" : [[]]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    {"!" : [[]]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLogicalNot_withNumbers() {
        var rule =
                """
                    { "!" : 0 }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    { "!" : 1 }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLogicalNot_withStrings() {
        var rule =
                """
                    {"!" : ""}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    {"!" : ""}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                    {"!" : "1"}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLogicalNot_withNull() {
        let rule =
                """
                    {"!" : null}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLogicalNot_withVariables() {
        let data =
                """
                    { "a" : "b", "b" : "1", "oneNest" : {"one" : true} }
                """

        var rule =
                """
                    { "!" : [ {"var" : ["oneNest.one"] } ] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data ))

        rule =
                """
                    { "!" : {"var" : ["a"] } }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data ))

        rule =
                """
                    { "!" : {"var" : ["nonExistant"] } }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data ))
    }

    static var allTests = [
        ("testEqualsWithDifferentSameConstants", testNot_StrictEquals_withConstants),
        ("testNot_StrictEquals_withConstants1", testNot_StrictEquals_withConstants1),
        ("testNot_StrictEquals_withConstants2", testNot_StrictEquals_withConstants2),
        ("testNot_StrictEquals_withConstants3", testNot_StrictEquals_withConstants3),
        ("testNotStringEquals_NestedVar", testNotStringEquals_NestedVar),
        ("testLogicalNot_withBooleanConstants", testLogicalNot_withBooleanConstants),
        ("testLogicalNot_withArrays", testLogicalNot_withArrays),
        ("testLogicalNot_withNumbers", testLogicalNot_withNumbers),
        ("testLogicalNot_withStrings", testLogicalNot_withStrings),
        ("testLogicalNot_withNull", testLogicalNot_withNull),
        ("testLogicalNot_withVariables", testLogicalNot_withVariables)
    ]
}
