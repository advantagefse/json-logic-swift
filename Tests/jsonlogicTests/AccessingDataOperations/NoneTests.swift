//
//  IfTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic

class NoneTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testNone() {
        var rule =
                """
                {"none":[{"var":"integers"}, {">=":[{"var":""}, 1]}]}
                """
        let data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"none":[{"var":"integers"}, {"==":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"none":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))
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
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))
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
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {">":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
        """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"none":[ {"var":"items"}, {"<":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
        """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))
    }

    static var allTests = [
        ("testNone", testNone),
        ("testNone_WithEmptyDataArray", testNone_WithEmptyDataArray),
        ("testNone_WithNestedDataItems", testNone_WithNestedDataItems),
    ]
}
