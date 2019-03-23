//
//  IfTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic

class AllTests: XCTestCase {

    let emptyIntArray = [Int]()

    func testAll() {
        var rule =
                """
                {"all":[{"var":"integers"}, {">=":[{"var":""}, 1]}]}
                """
        var data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"==":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        data =
                """
                {"integers":[]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertEqual(true, try applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {">":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {"<":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))

        rule =
                """
                 {"all":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[]}
                """
        XCTAssertEqual(false, try applyRule(rule, to: data))
    }

}
