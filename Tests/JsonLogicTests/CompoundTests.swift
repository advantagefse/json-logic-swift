//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class CompoundTests: XCTestCase {

    func testCompound() {
        var rule =
        """
        {"and":[{">":[3,1]},true]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: "{}"))

        rule =
        """
        {"and":[{">":[3,1]},false]}
        """
        XCTAssertEqual(false, try applyRule(rule, to: "{}"))

        rule =
        """
        {"and":[{">":[3,1]},{"!":true}]}
        """
        XCTAssertEqual(false, try applyRule(rule, to: "{}"))

        rule =
        """
        {"and":[{">":[3,1]},{"<":[1,3]}]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: "{}"))

        rule =
        """
        {"?:":[{">":[3,1]},"visible","hidden"]}
        """
        XCTAssertEqual("visible", try applyRule(rule, to: "{}"))
    }
}
