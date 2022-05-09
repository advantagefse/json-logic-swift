//
//  BetweenTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class BetweenTests: XCTestCase {

    func testBetween_withNumberConstants() {
        var rule =
        """
        { "<" : [1, 2, 3] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        { "<" : [1, 1, 3] }
        """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<" : [1, 3, 3] }
        """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [1, 3, 3] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [2, 2, 3] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
         { "<=" : [1, 4, 3] }
        """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

//    func testBetween_withNonNumbericConstants() {
//        let rulesAndResults = [
//            //When both are strings the comparison in done lexicographaclly e.g. "111111" < "2"
//            """
//            { "<" : ["1", "2222", "3"] }
//            """ : true,
//            """
//            { "<=" : ["2", "2", "3"] }
//            """ : true,
//            """
//            { "<" : ["2", "2", "3"] }
//            """ : false,
//            """
//            { "<=" : [null, [], "2"] }
//            """ : true,
//            """
//            { "<" : [null, [], "2"] }
//            """ : false
//        ]
//
//        for (rule, result) in rulesAndResults {
//            XCTAssertEqual(result, try applyRule(rule, to: nil))
//        }
//    }

//    func testBetween_withMixedNumbericAndNonConstants() {
//        let rulesAndResults = [
//            //When one is numeric then the other is converted to numberic
//            """
//            { "<=" : ["111", "2", 1111] }
//            """ : true,
//            """
//            { "<=" : ["1", "2222", 11111] }
//            """ : false,
//            """
//            { "<=" : [1, "b", 1111] }
//            """ : false,
//            //Anything but null when compared with null is greater
//            """
//            { "<" : [0, 1, null] }
//            """ : false,
//            """
//            { "<=" : [[], 0, "2"] }
//            """ : true,
//            """
//            { "<=" : [10, 10, "11"] }
//            """ : true,
//            """
//            { "<=" : [null, [], null] }
//            """ : false,
//            """
//            { "<=" : [null, [], 2] }
//            """ : true,
//            """
//            { "<=" : ["11", "2", 3] }
//            """ : true,
//            """
//            { "<=" : ["", 1, [[]]] }
//            """ : false
//        ]
//
//        for (rule, result) in rulesAndResults {
//            XCTAssertEqual(result, try applyRule(rule, to: nil))
//        }
//    }

    func testBetween_withVariables() {
        var rule =
        """
        { "<=" : [3, {"var" : ["b"]}, 9] }
        """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [0, {"var" : ["b"] }, 2] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [1, {"var" : ["a"] }, 9] }
        """
        XCTAssertEqual(false, try applyRule(rule, to: nil))

        rule =
        """
        { "<=" : [1, 3, 3] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))
    }
}
