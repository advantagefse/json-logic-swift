//
//  LessThanOrEqualTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class LessThanOrEqualTests: XCTestCase {

    func testLessThan_withNumberConstants() {
        var rule =
                """
                { "<=" : [1, 3] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "<=" : [1, 1] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "<=" : [3, 1] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testLessThan_withNonNumericConstants() {
        var rule =
                """
                { "<=" : ["2", "1111"] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
                """
                { "<=" : [null, null] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "<=" : [null, []] }
                """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
                """
                { "<=" : ["1", ""] }
                """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testLessThan_withMixedArgumentTypes() {
        var rule =
        """
        { "<=" : ["2", 1111] }
        """
          XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : ["2222", 1111] }
        """
          XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : ["b", 1111] }
        """
          XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [1, null] }
        """
          XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [1, []] }
        """
          XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [[[]], 0] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))
    }

    func testLessThan_withVariables() {
        let data =
        """
            { "a" : "b", "b" : "1", "oneNest" : {"one" : true} }
        """

        var rule =
        """
        { "<=" : [3, {"var" : ["oneNest.one"]} ] }
        """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
        """
        { "<=" : [1, {"var" : ["b"] }] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
        """
        { "<=" : [1, ["nonExistant"]] }
        """
        //note that http://jsonlogic.com/play.html returns false
        XCTAssertEqual(false, try applyRule(rule, to: data))
    }
}
