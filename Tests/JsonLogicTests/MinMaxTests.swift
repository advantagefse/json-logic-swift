//
//  Arithmetic.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class MinMaxTests: XCTestCase {

    func testMin_MultiplePositiveValues() {
        var rule = """
                   { "min" : [1, 2, 3] }
                   """
        XCTAssertEqual(1, try applyRule(rule, to: nil))

        rule = """
               { "min" : [1, 1, 3] }
               """
        XCTAssertEqual(1, try applyRule(rule, to: nil))

        rule = """
               { "min" : [3, 2, 1] }
               """
        XCTAssertEqual(1, try applyRule(rule, to: nil))
    }

    func testMin_SinglePositiveItem() {
        let rule = """
                   { "min" : [1] }
                   """
        XCTAssertEqual(1, try applyRule(rule, to: nil))
    }

    func testMin_MultipleNegativeValues() {
        var rule = """
                   { "min" : [-1, -2] }
                   """
        XCTAssertEqual(-2, try applyRule(rule, to: nil))

        rule = """
               { "min" : [-1, 1] }
               """
        XCTAssertEqual(-1, try applyRule(rule, to: nil))
    }

    func testMax_MultiplePositiveValues() {
        var rule = """
                   { "max" : [1, 2, 3] }
                   """
        XCTAssertEqual(3, try applyRule(rule, to: nil))

        rule = """
        { "max" : [1, 1, 3] }
        """
        XCTAssertEqual(3, try applyRule(rule, to: nil))

        rule = """
        { "max" : [3, 2, 1] }
        """
        XCTAssertEqual(3, try applyRule(rule, to: nil))
    }

    func testMax_SinglePositiveItem() {
        let rule = """
                   { "max" : [1] }
                   """
        XCTAssertEqual(1, try applyRule(rule, to: nil))
    }

    func testMax_MultipleNegativeValues() {
        var rule = """
                   { "max" : [-1, -2] }
                   """
        XCTAssertEqual(-1, try applyRule(rule, to: nil))

        rule = """
               { "max" : [-1, 1] }
               """
        XCTAssertEqual(1, try applyRule(rule, to: nil))
    }
}
