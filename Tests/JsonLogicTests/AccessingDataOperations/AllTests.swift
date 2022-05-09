//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

class AllTests: XCTestCase {

    let emptyIntArray = [Int]()

    func testAll_withCurrentArrayElement() {
        var rule =
                """
                {"all":[{"var":"integers"}, {">=":[{"var":""}, 1]}]}
                """
        var data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertTrue(try applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"==":[{"var":""}, 1]}]}
                """
        XCTAssertFalse(try applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        XCTAssertFalse(try applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"<=":[{"var":""}, 1]}]}
                """
        XCTAssertFalse(try applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        data =
                """
                {"integers":[]}
                """
        XCTAssertFalse(try applyRule(rule, to: data))
    }

    func testAll_withNestedArrayElement() {
        var rule =
                """
                {"all":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
                """
        var data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertTrue(try applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {">":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertFalse(try applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {"<":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertFalse(try applyRule(rule, to: data))
    }

    func testAll_withEmptyDataArray() {
        let rule =
                """
                 {"all":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
                """
        let data =
                """
                {"items":[]}
                """
        XCTAssertFalse(try applyRule(rule, to: data))
    }

    func testAll_withMissingArguments() {
        let rule =
                """
                 {"all":[]}
                """
        XCTAssertNil(try applyRule(rule))
    }
}
