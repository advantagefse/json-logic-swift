//
//  IfTests.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

class AllTests: XCTestCase {

    let jsonLogic = JsonLogic()
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
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"==":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"all":[{"var":"integers"}, {"<":[{"var":""}, 1]}]}
                """
        data =
                """
                {"integers":[]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertEqual(true, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {">":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"all":[ {"var":"items"}, {"<":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[{"qty":1,"sku":"apple"},{"qty":2,"sku":"banana"}]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                 {"all":[ {"var":"items"}, {">=":[{"var":"qty"}, 1]}]}
                """
        data =
                """
                {"items":[]}
                """
        XCTAssertEqual(false, try jsonLogic.applyRule(rule, to: data))
    }

    static var allTests = [
        ("testAll", testAll)
    ]
}
