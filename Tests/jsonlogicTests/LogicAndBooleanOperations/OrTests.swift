//
//  OrTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 12/02/2019.
//

import XCTest

@testable import jsonlogic

class OrTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testOr_twoBooleans() {
        var rule =
                """
                {"or": [true, true]}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "or" : [true, false] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "or" : [false, false] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "or" : [true] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "or" : [false] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testOr_mixedArguments() {
        XCTAssertEqual(1, try jsonLogic.applyRule("""
                { "or": [1, 3] }
                """, to: nil))

        XCTAssertEqual("a", try jsonLogic.applyRule("""
                { "or": ["a"] }
                """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
                { "or": [true,"",3] }
                """, to: nil))
    }

    static var allTests = [
        ("testOr_twoBooleans", testOr_twoBooleans),
        ("testOr_mixedArguments", testOr_mixedArguments)
    ]
}
