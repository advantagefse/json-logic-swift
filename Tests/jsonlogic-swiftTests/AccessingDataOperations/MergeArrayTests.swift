//
//  IfTests.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

class MergeTests: XCTestCase {

    let jsonLogic = JsonLogic()
    let emptyIntArray = [Int]()

    func testMerge() {
        var rule =
                """
                {"merge":[]}
                """
        XCTAssertEqual(emptyIntArray, try jsonLogic.applyRule(rule, to: nil))
        rule =
                """
                {"merge":[[1]]}
                """
        XCTAssertEqual([1], try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1],[]]}
                """
        XCTAssertEqual([1], try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1],[2]]}
                """
        XCTAssertEqual([1, 2], try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1], [2], [3]]}
                """
        XCTAssertEqual([1, 2, 3], try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"merge":[[1, 2], [3]]}
                """
        XCTAssertEqual([1, 2, 3], try jsonLogic.applyRule(rule, to: nil))
    }

    func testMerge_withNonArrayArguments() {
        var rule =
                """
                {"merge":1}
                """
        XCTAssertEqual([1], try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"merge":[1,2]}
                """
        XCTAssertEqual([1, 2], try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"merge":[1,[2]]}
                """
        XCTAssertEqual([1, 2], try jsonLogic.applyRule(rule, to: nil))
    }

    static var allTests = [
        ("testMerge", testMerge),
        ("testMerge_withNonArrayArguments", testMerge_withNonArrayArguments)
    ]
}
