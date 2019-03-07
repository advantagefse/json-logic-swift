//
//  AndTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 12/02/2019.
//

import XCTest

@testable import jsonlogic

class DoubleNegationTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testDoubleNegation_withBooleans() {
        XCTAssertEqual(false, try jsonLogic.applyRule("""
            { "and" : [false] }
            """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
            { "and" : [true] }
            """, to: nil))
    }

    func testDoubleNegation_withArrays() {
        XCTAssertEqual(false, try jsonLogic.applyRule("""
            { "!!" : [ [] ] }
            """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
            { "!!" : [ [0] ] }
            """, to: nil))
    }

    func testDoubleNegation_withStrings() {
        XCTAssertEqual(false, try jsonLogic.applyRule("""
            { "!!" : [ "" ] }
            """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
            { "!!" : [ "0" ] }
            """, to: nil))
    }

    func testDoubleNegation_withNumbers() {
        XCTAssertEqual(false, try jsonLogic.applyRule("""
            { "!!" : [ 0 ] }
            """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
            { "!!" : [ 1 ] }
            """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
            { "!!" : [ -1 ] }
            """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
            { "!!" : [ 1000 ] }
            """, to: nil))
    }

    func testDoubleNegation_withNull() {
        XCTAssertEqual(false, try jsonLogic.applyRule("""
            { "!!" : [ null ] }
            """, to: nil))
    }

    static var allTests = [
        ("testDoubleNegation_withBooleans", testDoubleNegation_withBooleans),
        ("testDoubleNegation_withArrays", testDoubleNegation_withArrays)
    ]
}
