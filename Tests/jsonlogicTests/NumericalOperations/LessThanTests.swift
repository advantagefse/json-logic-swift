//
//  lessThanTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic

class LessThanTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testLessThan_withNumberConstants() {
        var rule =
                """
                { "<" : [1, 3] }
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, 1] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [3, 1] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLessThan_withNonNumbericConstants() {
        var rule =
                """
                { "<" : ["2", "1111"] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [null, null] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [null, []] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : ["1", ""] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLessThan_withMixedArgumentsTypes() {
        var rule =
                """
                { "<" : ["2", 1111] }
                """
        //When one is numeric then the other is converted to numberic
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : ["2222", 1111] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : ["b", 1111] }
                """
        //Anything but null when compared with null is greater
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, null] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, []] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [[[]], 0] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testLessThan_withVariables() {
        var rule =
                """
                { "<" : [3, {"var" : ["oneNest.one"]}] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, {"var" : ["a"] }] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [1, ["nonExistant"]] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                { "<" : [0, ["b"]] }
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    static var allTests = [
        ("testLessThan_withNumberConstants", testLessThan_withNumberConstants),
        ("testLessThan_withNonNumbericConstants", testLessThan_withNonNumbericConstants),
        ("testLessThan_withMixedArgumentsTypes", testLessThan_withMixedArgumentsTypes),
        ("testLessThan_withVariables", testLessThan_withVariables)
    ]
}
