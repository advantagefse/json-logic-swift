//
//  Arithmetic.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

class MinMaxTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testMin_MultiplePositiveValues() {
        var rule = """
                   { "min" : [1, 2, 3] }
                   """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))

        rule = """
               { "min" : [1, 1, 3] }
               """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))

        rule = """
               { "min" : [3, 2, 1] }
               """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))
    }

    func testMin_SinglePositiveItem() {
        let rule = """
                   { "min" : [1] }
                   """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))
    }

    func testMin_MultipleNegativeValues() {
        var rule = """
                   { "min" : [-1, -2] }
                   """
        XCTAssertEqual(-2, try jsonLogic.applyRule(rule, to: nil))

        rule = """
               { "min" : [-1, 1] }
               """
        XCTAssertEqual(-1, try jsonLogic.applyRule(rule, to: nil))
    }

    func testMax_MultiplePositiveValues() {
        var rule = """
                   { "max" : [1, 2, 3] }
                   """
        XCTAssertEqual(3, try jsonLogic.applyRule(rule, to: nil))

        rule = """
        { "max" : [1, 1, 3] }
        """
        XCTAssertEqual(3, try jsonLogic.applyRule(rule, to: nil))

        rule = """
        { "max" : [3, 2, 1] }
        """
        XCTAssertEqual(3, try jsonLogic.applyRule(rule, to: nil))
    }

    func testMax_SinglePositiveItem() {
        let rule = """
                   { "max" : [1] }
                   """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))
    }

    func testMax_MultipleNegativeValues() {
        var rule = """
                   { "max" : [-1, -2] }
                   """
        XCTAssertEqual(-1, try jsonLogic.applyRule(rule, to: nil))

        rule = """
               { "max" : [-1, 1] }
               """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))
    }

    static var allTests = [
        ("testMin_MultiplePositiveValues", testMin_MultiplePositiveValues),
        ("testMin_SinglePositiveItem", testMin_SinglePositiveItem),
        ("testMin_MultipleNegativeValues", testMin_MultipleNegativeValues),
        ("testMax_MultiplePositiveValues", testMax_MultiplePositiveValues),
        ("testMax_SinglePositiveItem", testMax_SinglePositiveItem),
        ("testMax_MultipleNegativeValues", testMax_MultipleNegativeValues)
    ]
}
