//
//  IfTests.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

//swiftlint:disable function_body_length
class CatTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testCat() {
        var rule =
        """
        {"cat":"ice"}
        """
        XCTAssertEqual("ice", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":["ice"]}
        """
        XCTAssertEqual("ice", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":["ice","cream"]}
        """
        XCTAssertEqual("icecream", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,2]}
        """
        XCTAssertEqual("12", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1.1,2.1]}
        """
        XCTAssertEqual("1.12.1", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":["Robocop",2]}
        """
        XCTAssertEqual("Robocop2", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":["we all scream for ","ice","cream"]}
        """
        XCTAssertEqual("we all scream for icecream", try jsonLogic.applyRule(rule, to: nil))
    }

    func testCat_WithNullOrEmpty() {
        var rule =
        """
        {"cat":[1,null]}
        """
        XCTAssertEqual("1", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,[]]}
        """
        XCTAssertEqual("1", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,""]}
        """
        XCTAssertEqual("1", try jsonLogic.applyRule(rule, to: nil))
    }

    func testCat_WithBoolean() {
        var rule =
        """
        {"cat":["jsonlogic", true]}
        """
        XCTAssertEqual("jsonlogictrue", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":[false, true]}
        """
        XCTAssertEqual("falsetrue", try jsonLogic.applyRule(rule, to: nil))
    }

    func testCat_WithArrays() {
        var rule =
        """
        {"cat":[1,[2,3]]}
        """
        XCTAssertEqual("12,3", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":[[1]]}
        """
        XCTAssertEqual("1", try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,[false,true]]}
        """
        XCTAssertEqual("1false,true", try jsonLogic.applyRule(rule, to: nil))
    }

    static var allTests = [
        ("testCat", testCat)
    ]
}
