//
//  IfTests.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic_swift

//swiftlint:disable function_body_length
class ArrayMapTests: XCTestCase {

    let jsonLogic = JsonLogic()
    let emptyIntArray = [Int]()

    func testMap() {
        var rule =
                """
                {"map":[{"var":"integers"}, {"*":[{"var":""},2]}]}
                """
        var data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual([2, 4, 6], try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"map":[{"var":"integers"}, {"*":[{"var":""},2]}]}
                """
        XCTAssertEqual(emptyIntArray, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"map":[{"var":"desserts"}, {"var":"qty"}]}
                """
        data =
                """
                {"desserts":[
                {"name":"apple","qty":1},
                {"name":"brownie","qty":2},
                {"name":"cupcake","qty":3}
                ]}
                """
        XCTAssertEqual([1, 2, 3], try jsonLogic.applyRule(rule, to: data))
    }

    func testReduce() {
        var rule =
                """
                {"reduce":[
                {"var":"integers"},
                {"+":[{"var":"current"}, {"var":"accumulator"}]},
                0
                ]}
                """
        var data =
                """
                {"integers":[1,2,3,4]}
                """
        XCTAssertEqual(10, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"reduce":[
                {"var":"integers"},
                {"+":[{"var":"current"}, {"var":"accumulator"}]},
                0
                ]}
                """
        XCTAssertEqual(0, try jsonLogic.applyRule(rule, to: nil))

        rule =
                """
                {"reduce":[
                {"var":"integers"},
                {"*":[{"var":"current"}, {"var":"accumulator"}]},
                1
                ]}
                """
        data =
                """
                {"integers":[1,2,3,4]}
                """
        XCTAssertEqual(24, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"reduce":[
                {"var":"integers"},
                {"*":[{"var":"current"}, {"var":"accumulator"}]},
                0
                ]}
                """
        data =
                """
                {"integers":[1,2,3,4]}
                """
        XCTAssertEqual(0, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"reduce": [
                {"var":"desserts"},
                {"+":[ {"var":"accumulator"}, {"var":"current.qty"}]},
                0
                ]}
                """
        data =
                """
                {"desserts":[
                {"name":"apple","qty":1},
                {"name":"brownie","qty":2},
                {"name":"cupcake","qty":3}
                ]}
                """
        XCTAssertEqual(6, try jsonLogic.applyRule(rule, to: data))
    }

    func testFilter() {
        var rule =
                """
                {"filter":[{"var":"integers"}, true]}
                """
        var data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual([1,2,3], try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"filter":[{"var":"integers"}, false]}
                """
        data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual(emptyIntArray, try jsonLogic.applyRule(rule, to: data))

        rule =
                """
                {"filter":[{"var":"integers"}, {">=":[{"var":""},2]}]}
                """
        data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual([2,3], try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"filter":[{"var":"integers"}, {"%":[{"var":""},2]}]}
        """
        data =
        """
        {"integers":[1,2,3]}
        """
        XCTAssertEqual([1,3], try jsonLogic.applyRule(rule, to: data))
    }

    static var allTests = [
        ("testMap", testMap),
        ("testReduce", testReduce),
        ("testFilter", testFilter)
    ]
}
