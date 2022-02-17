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

    func testVar_withDefaultArgument_GivenArgumentIsMissing() {
        let rule =
                    """
                     {"var": ["a"]}
                    """
        XCTAssertNil(try applyRule(rule))
    }

    func testVar_withDefaultArgument() {
        let rule =
                    """
                     {"var": ["a", 0]}
                    """
        XCTAssertEqual(try applyRule(rule), 0)
    }

    func testVar_withInvalidVarPath() {
        let rule =
                    """
                     {"var": ["a..b"]}
                    """
        XCTAssertNil(try applyRule(rule))
    }

    func testVar_withInvalidVarPath_GivenArgumentIsMissing() {
        let rule =
                    """
                     {"var": ["a..b", 0]}
                    """
        XCTAssertEqual(try applyRule(rule), 0)
    }

    func testVar_withDefaultArgumentString() {
        let rule =
                    """
                     {"var": ["a", "0"]}
                    """
        XCTAssertEqual(try applyRule(rule), "0")
    }

    func testVar_withDefaultArgumentString_GivenArgumentExistsInData() {
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

    func testVar_withDefaultArgumentString_GivenArgumentDoesNotExistsInData() {
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

    func testVar_withDefaultArgumentString_GivenNestedArgumentDoesNotExistsInData() {
        let rule =
                    """
                     {"var": ["a.b", "0"]}
                    """
        let data =
                """
                {"a": "1"}
                """
        XCTAssertEqual(try applyRule(rule, to: data), "0")
    }

    
}
