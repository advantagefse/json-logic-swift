//
//  GreaterThanOrEqualsTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class GreaterThanOrEqualTests: XCTestCase {

    func testGreaterThan_withNumberConstants() {
        var rule =
                """
                { ">=" : [3, 1] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { ">=" : [1, 1] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { ">=" : [1, 3] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testGreaterThan_withNonNumbericConstants() {
        var rule =
        """
        { ">=" : ["2", "1111"] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        { ">=" : [null, null] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        { ">=" : [null, []] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        { ">=" : ["1", ""] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))
    }

    func testGreaterThan_withMixedArgumentTypes() {
        var rule =
                """
                { ">=" : ["2", 1111] }
                """
          XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { ">=" : ["2222", 1111] }
                """
          XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { ">=" : ["b", 1111] }
                """
          XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { ">=" : [1, null] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { ">=" : [1, []] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { ">=" : [[[]], 0] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))
    }

    func testGreaterThan_withVariables() {
        var rule =
                """
                { ">=" : [3, {"var" : ["oneNest.one"]} ] }
                """
        let data =
                """
                    { "a" : "b", "b" : "1", "oneNest" : {"one" : true} }
                """
          XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
                """
                { ">=" : [1, {"var" : ["oneNest.one"]} ] }
                """
          XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
                """
                { ">=" : [1, {"var" : ["a"] }] }
                """
          XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                { ">=" : [1, ["nonExistent"]] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))
    }
}
