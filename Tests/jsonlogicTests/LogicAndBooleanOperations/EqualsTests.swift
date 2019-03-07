//
//  EqualsTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 17/02/2019.
//

import Foundation
import XCTest
@testable import jsonlogic

class EqualsTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testEquals() {
        var rule =
        """
        {"==":[1,1]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"==":[1,2]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testEquals_WithTypeCoercion() {
        var rule =
        """
        {"==":[1,"1"]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"==":[1,"2"]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"==":[1,"1.0"]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"==":[null,1]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"==":[0,false]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"==":[[1],[1]]}
        """
        //http://jsonlogic.com/play.html returns false here
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    func testNotEquals() {
        var rule =
        """
        {"!=":[1,2]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"!=":[1,1]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"!=":[1,"1"]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))
    }

    func testNotEquals_WithTypeCoersion() {
        var rule =
        """
        {"!=":[1,"1"]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"!=":[1,"1.0"]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"!=":[0,true]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: nil))
    }

    static var allTests = [
        ("testEquals", testEquals),
        ("testEquals_WithTypeCoercion", testEquals_WithTypeCoercion),
        ("testNotEquals", testNotEquals),
        ("testNotEquals_WithTypeCoersion", testNotEquals_WithTypeCoersion)
    ]
}
