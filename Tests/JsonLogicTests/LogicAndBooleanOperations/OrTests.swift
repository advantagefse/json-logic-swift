//
//  OrTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 12/02/2019.
//

import XCTest

@testable import JsonLogic

class OrTests: XCTestCase {

    func testOr_twoBooleans() {
        var rule =
                """
                {"or": [true, true]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "or" : [true, false] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "or" : [false, false] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "or" : [true] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "or" : [false] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testOr_mixedArguments() {
        XCTAssertEqual(1, try applyRule("""
                { "or": [1, 3] }
                """, to: nil))

        XCTAssertEqual("a", try applyRule("""
                { "or": ["a"] }
                """, to: nil))

        XCTAssertEqual(true, try applyRule("""
                { "or": [true,"",3] }
                """, to: nil))
    }
}
