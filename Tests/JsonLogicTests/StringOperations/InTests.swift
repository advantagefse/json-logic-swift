//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class InTests: XCTestCase {

    func testIn_StringArgument() {
        var rule =
        """
        { "in" : ["Spring", "Springfield"] }
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        {"in":["Spring","Springfield"]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        {"in":["i","team"]}
        """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }

    func testIn_ArrayArgument() {
        var rule =
        """
        {"in":["Bart",["Bart","Homer","Lisa","Marge","Maggie"]]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: nil))

        rule =
        """
        {"in":["Milhouse",["Bart","Homer","Lisa","Marge","Maggie"]]}
        """
        XCTAssertEqual(false, try applyRule(rule, to: nil))
    }
}
