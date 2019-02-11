//
//  Arithmetic.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

class Arithmetic: XCTestCase {

    let jsonLogic = JsonLogic()

    func testAddition() {
        var rule =
        """
        { "+" : [4, 2] }
        """
        XCTAssertEqual(6, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        { "+" : [4, "2"] }
        """
        XCTAssertEqual(6, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        { "+" : [2, 2, 2, 2, 2]}
        """
        XCTAssertEqual(10, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        { "+" : "3.14"}
        """
        XCTAssertEqual(3.14, try jsonLogic.applyRule(rule, to: nil))
    }

    func testSubtraction() {
        var rule =
                """
                { "-" : [4, 2] }
                """
        XCTAssertEqual(2, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "-" : [2, 3] }
                """
        XCTAssertEqual(-1, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "-" : [3] }
                """
        XCTAssertEqual(-3, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                 { "-" : [1, "1"] }
                """
        XCTAssertEqual(0, try jsonLogic.applyRule(rule, to: nil))
    }

    func testMultiplication() {
        var rule =
                """
                { "*" : [4, 2] }
                """
        XCTAssertEqual(8, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "*" : [2, 2, 2, 2, 2]}
                """
        XCTAssertEqual(32, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "*" : [3, 2] }
                """
        XCTAssertEqual(6, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "*" : [1]}
                """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "*" : ["1", 1]}
                """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))
    }

    func testMultiplication_TypeCoercion() {
        var rule =
        """
        {"*":["2","2"]}
        """
        XCTAssertEqual(4, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"*":["2"]}
        """
        XCTAssertEqual(2, try jsonLogic.applyRule(rule, to: nil))
    }

    func testDivision() {
        var rule =
        """
        { "/" : [4, 2]}
        """
        XCTAssertEqual(2, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        { "/" : [2, 4]}
        """
        XCTAssertEqual(0.5, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        { "+" : [2, 2, 2, 2, 2]}
        """
        XCTAssertEqual(10, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        { "/" : ["1", 1]}
        """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))
    }

    func testModulo() {
        var rule =
                """
                { "%" : [1, 2]}
                """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "%" : [2, 2]}
                """
        XCTAssertEqual(0, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "%" : [3, 2]}
                """
        XCTAssertEqual(1, try jsonLogic.applyRule(rule, to: nil))
    }

    func testUnaryMinus() {
        var rule =
                """
                { "-" : [2] }
                """
        XCTAssertEqual(-2, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "-" : [-2] }
                """
        XCTAssertEqual(2, try jsonLogic.applyRule(rule, to: nil))
    }

    static var allTests = [
        ("testAddition", testAddition),
        ("testSubstraction", testSubtraction),
        ("testMultiplication", testMultiplication),
        ("testMultiplication_TypeCoercion", testMultiplication_TypeCoercion),
        ("testDivision", testDivision),
        ("testModulo", testModulo),
        ("testUnaryMinus", testUnaryMinus)
    ]
}
