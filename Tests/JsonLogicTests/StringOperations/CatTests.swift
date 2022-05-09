//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

//swiftlint:disable function_body_length
class CatTests: XCTestCase {

    func testCat() {
        var rule =
        """
        {"cat":"ice"}
        """
        XCTAssertEqual("ice", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":["ice"]}
        """
        XCTAssertEqual("ice", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":["ice","cream"]}
        """
        XCTAssertEqual("icecream", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,2]}
        """
        XCTAssertEqual("12", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":[221.1,2.122]}
        """
        XCTAssertEqual("221.12.122", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":["Robocop",2]}
        """
        XCTAssertEqual("Robocop2", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":["we all scream for ","ice","cream"]}
        """
        XCTAssertEqual("we all scream for icecream", try applyRule(rule, to: nil))
    }

    func testCat_WithNullOrEmpty() {
        var rule =
        """
        {"cat":[1,null]}
        """
        XCTAssertEqual("1", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,[]]}
        """
        XCTAssertEqual("1", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,""]}
        """
        XCTAssertEqual("1", try applyRule(rule, to: nil))
    }

    func testCat_WithBoolean() {
        var rule =
        """
        {"cat":["jsonlogic", true]}
        """
        XCTAssertEqual("jsonlogictrue", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":[false, true]}
        """
        XCTAssertEqual("falsetrue", try applyRule(rule, to: nil))
    }

    func testCat_WithArrays() {
        var rule =
        """
        {"cat":[1,[2,3]]}
        """
        XCTAssertEqual("12,3", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":[[1]]}
        """
        XCTAssertEqual("1", try applyRule(rule, to: nil))

        rule =
        """
        {"cat":[1,[false,true]]}
        """
        XCTAssertEqual("1false,true", try applyRule(rule, to: nil))
    }
}
