//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class MergeTests: XCTestCase {

    let emptyIntArray = [Int]()

    func testMerge() {
        var rule =
                """
                {"merge":[]}
                """
        XCTAssertEqual(emptyIntArray, try applyRule(rule, to: nil))
        rule =
                """
                {"merge":[[1]]}
                """
        XCTAssertEqual([1], try applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1],[]]}
                """
        XCTAssertEqual([1], try applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1],[2]]}
                """
        XCTAssertEqual([1, 2], try applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1], [2], [3]]}
                """
        XCTAssertEqual([1, 2, 3], try applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1, 2], [3]]}
                """
        XCTAssertEqual([1, 2, 3], try applyRule(rule, to: nil))
    }

    func testMerge_withNonArrayArguments() {
        var rule =
                """
                {"merge":1}
                """
        XCTAssertEqual([1], try applyRule(rule, to: nil))

        rule =
                """
                {"merge":[1,2]}
                """
        XCTAssertEqual([1, 2], try applyRule(rule, to: nil))

        rule =
                """
                {"merge":[1,[2]]}
                """
        XCTAssertEqual([1, 2], try applyRule(rule, to: nil))
    }
}
