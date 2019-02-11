//
//  IfTests.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

class SubstringTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testSubstring() {
        var rule =
                """
                {"substr":["jsonlogic", 4]}
                """
        XCTAssertEqual("logic", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5]}
                """
        XCTAssertEqual("logic", try jsonLogic.applyRule(rule, to: nil))
    }

    func testSubstring_withRange() {
        var rule =
                """
                {"substr":["jsonlogic", 0, 1]}
                """
        XCTAssertEqual("j", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -1, 1]}
                """
        XCTAssertEqual("c", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", 4, 5]}
                """
        XCTAssertEqual("logic", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5, 5]}
                """
        XCTAssertEqual("logic", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5, -2]}
                """
        XCTAssertEqual("log", try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", 1, -5]}
                """
        XCTAssertEqual("son", try jsonLogic.applyRule(rule, to: nil))
    }

    func testSunString_withInvalidLength() {
        let rule =
                """
                {"substr":["jsonlogic", 1, null]}
                """
        XCTAssertNil(try jsonLogic.applyRule(rule, to: nil))
    }

    func testSunString_withInvalidStart() {
        var rule =
                """
                {"substr":["jsonlogic", null, 1]}
                """
        XCTAssertNil(try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", null]}
                """
        XCTAssertNil(try jsonLogic.applyRule(rule, to: nil))
    }

    static var allTests = [
        ("testSubstring", testSubstring),
        ("testSubstring_withRange", testSubstring_withRange),
        ("testSunString_withInvalidLength", testSunString_withInvalidLength),
        ("testSunString_withInvalidStart", testSunString_withInvalidStart)
    ]
}
