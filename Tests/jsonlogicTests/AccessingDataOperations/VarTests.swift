//
//  VarTests.swift
//  jsonlogic
//
//  Created by Christos Koninis on 2/12/22.
//

import XCTest
@testable import jsonlogic
import JSON

class VarTests: XCTestCase {

    let emptyIntArray = [Int]()

    func testAll_withMissingArgument() {
        let rule =
                    """
                     {"var": ["a", 0]}
                    """
        XCTAssertEqual(try applyRule(rule), 0)
    }

    func testAll_withMissingArgumentString() {
        let rule =
                    """
                     {"var": ["a", "0"]}
                    """
        XCTAssertEqual(try applyRule(rule), "0")
    }

    func testAll_withMissingArgumentString_GivenArgumentExistsInData() {
        let rule =
                    """
                     {"var": ["a", "0"]}
                    """
        let data =
                """
                {"a": "1"}
                """
        XCTAssertEqual(try applyRule(rule, to: data), "1")
    }

    func testAll_withMissingArgumentString_GivenArgumentDoesNotExistsInData() {
        let rule =
                    """
                     {"var": ["a", "0"]}
                    """
        let data =
                """
                {"b": "1"}
                """
        XCTAssertEqual(try applyRule(rule, to: data), "0")
    }
}
