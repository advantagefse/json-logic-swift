//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class LogTests: XCTestCase {

    func testLog() {
        let rule =
        """
        {"log":"apple"}
        """
        XCTAssertEqual("apple", try applyRule(rule, to: nil))
    }

    func testLog_withComplexExpression() {
        let rule =
                """
                {"log":{"cat":[1,[2,3]]}}
                """
        XCTAssertEqual("12,3", try applyRule(rule, to: nil))
    }

//swiftlint:disable:next function_body_length
    func testLog_nestedInOtherExpressions() {

        let rule =
"""
        {
            "if": [{
            "==": [{
                "log": {
                    "%": [{
                        "var": "i"
                    }, 15]
                }
            }, 0]
        }, "fizzbuzz", {
            "log": {
                "==": [{
                    "%": [{
                        "var": "i"
                    }, 3]
                }, 0]
            }
        }, "fizz", {
            "==": [{
                "%": [{
                    "var": "i"
                }, {
                    "log": 5
                }]
            }, 0]
        }, {
            "log": "buzz"
        }, {
            "var": "i"
        }]
        }
"""

        XCTAssertEqual("fizzbuzz", try applyRule(rule, to: "{\"i\" : 0}"))
        XCTAssertEqual(1, try applyRule(rule, to: "{\"i\" : 1}"))
        XCTAssertEqual(2, try applyRule(rule, to: "{\"i\" : 2}"))
        XCTAssertEqual("fizz", try applyRule(rule, to: "{\"i\" : 3}"))
        XCTAssertEqual("buzz", try applyRule(rule, to: "{\"i\" : 5}"))
        XCTAssertEqual("fizzbuzz", try applyRule(rule, to: "{\"i\" : 15}"))
        XCTAssertEqual("fizzbuzz", try applyRule(rule, to: "{\"i\" : 45}"))
    }
}
