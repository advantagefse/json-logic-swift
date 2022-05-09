//
//  AndTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 12/02/2019.
//

import XCTest

@testable import JsonLogic

class DoubleNegationTests: XCTestCase {

    func testDoubleNegation_withBooleans() {
        XCTAssertEqual(false, try applyRule("""
            { "and" : [false] }
            """, to: nil))

        XCTAssertEqual(true, try applyRule("""
            { "and" : [true] }
            """, to: nil))
    }

    func testDoubleNegation_withObject() {
        XCTAssertEqual(true, try applyRule("""
            { "!!" : true }
            """, to: nil))

        XCTAssertEqual(false, try applyRule("""
            { "!!" : false }
            """, to: nil))

        XCTAssertEqual(true, try applyRule("""
            { "!!" : "0" }
            """, to: nil))
    }

    func testDoubleNegation_withArrays() {
        XCTAssertEqual(false, try applyRule("""
            { "!!" : [ [] ] }
            """, to: nil))

        XCTAssertEqual(true, try applyRule("""
            { "!!" : [ [0] ] }
            """, to: nil))
    }

    func testDoubleNegation_withStrings() {
        XCTAssertEqual(false, try applyRule("""
            { "!!" : [ "" ] }
            """, to: nil))

        XCTAssertEqual(true, try applyRule("""
            { "!!" : [ "0" ] }
            """, to: nil))
    }

    func testDoubleNegation_withNumbers() {
        XCTAssertEqual(false, try applyRule("""
            { "!!" : [ 0 ] }
            """, to: nil))

        XCTAssertEqual(true, try applyRule("""
            { "!!" : [ 1 ] }
            """, to: nil))

        XCTAssertEqual(true, try applyRule("""
            { "!!" : [ -1 ] }
            """, to: nil))

        XCTAssertEqual(true, try applyRule("""
            { "!!" : [ 1000 ] }
            """, to: nil))
    }

    func testDoubleNegation_withNull() {
        XCTAssertEqual(false, try applyRule("""
            { "!!" : [ null ] }
            """, to: nil))
    }
}
