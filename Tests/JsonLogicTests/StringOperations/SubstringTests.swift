//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class SubstringTests: XCTestCase {

    func testSubstring() {
        var rule =
                """
                {"substr":["jsonlogic", 4]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))
    }

    func testSubstring_withRange() {
        var rule =
                """
                {"substr":["jsonlogic", 0, 1]}
                """
        XCTAssertEqual("j", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -1, 1]}
                """
        XCTAssertEqual("c", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", 4, 5]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5, 5]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5, -2]}
                """
        XCTAssertEqual("log", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", 1, -5]}
                """
        XCTAssertEqual("son", try applyRule(rule, to: nil))
    }

    func testSunString_withInvalidLength() {
        let rule =
                """
                {"substr":["jsonlogic", 1, null]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))
    }

    func testSunString_withInvalidStart() {
        var rule =
                """
                {"substr":["jsonlogic", null, 1]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", null]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))
    }
}
