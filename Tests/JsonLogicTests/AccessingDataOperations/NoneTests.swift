//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class NoneTests: XCTestCase {

    func testNone() {
        var rule =
                """
                {"none":[{"var":"integers"}, {">=":[{"var":""}, 1]}]}
                """
        let data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                {"none":[{"var":"integers"}, {"==":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                {"none":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
                """
                {"none":[{"var":"integers"}, {"<=":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))
    }

    func testNone_WithEmptyDataArray() {
        var rule =
        """
                {"none":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        var data =
        """
                {"integers":[]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: data))
    }

    func testNone_WithNestedDataItems() {
        var rule =
        """
                {"none":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
                """
        var data =
        """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {">":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
        """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {"<":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: data))
    }

    func testNone_WithMissingArguments() {
        var rule =
                """
                {"none":[{"var":"integers"}]}
                """
        XCTAssertNil(try applyRule(rule))

        rule =
                """
                {"none":[]}
                """
        XCTAssertNil(try applyRule(rule))
    }
}
