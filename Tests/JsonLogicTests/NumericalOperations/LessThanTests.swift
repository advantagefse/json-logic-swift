//
//  lessThanTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class LessThanTests: XCTestCase {

    func testLessThan_withNumberConstants() {
        var rule =
                """
                { "<" : [1, 3] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, 1] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [3, 1] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testLessThan_withNonNumbericConstants() {
        var rule =
                """
                { "<" : ["2", "1111"] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [null, null] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [null, []] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : ["1", ""] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testLessThan_withMixedArgumentsTypes() {
        var rule =
                """
                { "<" : ["2", 1111] }
                """
        //When one is numeric then the other is converted to numberic
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : ["2222", 1111] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : ["b", 1111] }
                """
        //Anything but null when compared with null is greater
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, null] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, []] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [[[]], 0] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testLessThan_withVariables() {
        var rule =
                """
                { "<" : [3, {"var" : ["oneNest.one"]}] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, {"var" : ["a"] }] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, ["nonExistant"]] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<" : [0, ["b"]] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }
}
