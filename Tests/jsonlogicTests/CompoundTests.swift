//
//  IfTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic

class CompoundTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testCompound() {
        var rule =
        """
        {"and":[{">":[3,1]},true]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: "{}"))

        rule =
        """
        {"and":[{">":[3,1]},false]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: "{}"))

        rule =
        """
        {"and":[{">":[3,1]},{"!":true}]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: "{}"))

        rule =
        """
        {"and":[{">":[3,1]},{"<":[1,3]}]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: "{}"))

        rule =
        """
        {"?:":[{">":[3,1]},"visible","hidden"]}
        """
        XCTAssertEqual("visible", try jsonLogic.applyRule(rule, to: "{}"))
    }

    static var allTests = [
        ("testCompound", testCompound)
    ]
}
