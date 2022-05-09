//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class SomeTests: XCTestCase {

    func testSome() {
        var rule =
                """
                {"some":[{"var":"integers"}, {">=":[{"var":""}, 1]}]}
                """
        let data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
                """
                {"some":[{"var":"integers"}, {"==":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
                """
                {"some":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                {"some":[{"var":"integers"}, {"<=":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: data))
    }

    func testSome_WithEmptyDataArray() {
        var rule =
                """
                {"some":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        var data =
                """
                {"integers":[]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
        """
        {"some":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[]}
        """
        XCTAssertEqual(false, try applyRule(rule, to: data))
    }

    func testNone_WithNestedDataItems() {
        var rule =
        """
        {"some":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
        """
        var data =
        """
        {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
        """
        {"some":[ {"var":"items"}, {">":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
        """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
        """
        {"some":[ {"var":"items"}, {"<":[{"var":"qty"}, 1]}]}
        """
        data =
        """
        {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
        """
        XCTAssertEqual(false, try applyRule(rule, to: data))
    }

    func testSome_WithMissingArguments() {
        var rule =
                """
                {"some":[{"var":"integers"}]}
                """
        XCTAssertNil(try applyRule(rule))

        rule =
                """
                {"some":[]}
                """
        XCTAssertNil(try applyRule(rule))
    }
}
