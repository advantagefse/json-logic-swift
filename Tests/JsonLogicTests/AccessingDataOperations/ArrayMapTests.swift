//
//  IfTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import JsonLogic

//swiftlint:disable function_body_length
class ArrayMapTests: XCTestCase {

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
        XCTAssertEqual([2, 4, 6], try applyRule(rule, to: data))

        rule =
                """
                {"map":[{"var":"integers"}, {"*":[{"var":""},2]}]}
                """
        XCTAssertEqual(emptyIntArray, try applyRule(rule, to: nil))

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
        XCTAssertEqual([1, 2, 3], try applyRule(rule, to: data))

        rule =
                """
                {"map":[{"var":"desserts"}]}
                """
        XCTAssertEqual(emptyIntArray, try applyRule(rule))
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
          XCTAssertEqual(10, try applyRule(rule, to: data))

        rule =
                """
                {"reduce":[
                {"var":"integers"},
                {"+":[{"var":"current"}, {"var":"accumulator"}]},
                0
                ]}
                """
          XCTAssertEqual(0, try applyRule(rule, to: nil))

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
        XCTAssertEqual(24, try applyRule(rule, to: data))

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
        XCTAssertEqual(0, try applyRule(rule, to: data))

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
        XCTAssertEqual(6, try applyRule(rule, to: data))
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
        XCTAssertEqual([1, 2, 3], try applyRule(rule, to: data))

        rule =
                """
                {"filter":[{"var":"integers"}, false]}
                """
        data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual(emptyIntArray, try applyRule(rule, to: data))

        rule =
                """
                {"filter":[{"var":"integers"}, {">=":[{"var":""},2]}]}
                """
        data =
                """
                {"integers":[1,2,3]}
                """
        XCTAssertEqual([2, 3], try applyRule(rule, to: data))

        rule =
            """
            {"filter":[{"var":"integers"}, {"%":[{"var":""},2]}]}
            """
        data =
            """
            {"integers":[1,2,3]}
            """
        XCTAssertEqual([1, 3], try applyRule(rule, to: data))

        rule =
            """
            {"filter":[{"var":"integers"}]}
            """
        XCTAssertEqual(emptyIntArray, try applyRule(rule, to: data))
    }

    func testFilter_withMissingArguments() {
        let rule =
                """
                 {"filter":[]}
                """
        XCTAssertEqual(emptyIntArray, try applyRule(rule))
    }

    func testReduce_withMissingArguments() {
        let rule =
                """
                 {"reduce":[]}
                """
        XCTAssertNil(try applyRule(rule))
    }

    func testMap_withMissingArguments() {
        let rule =
                """
                 {"map":[]}
                """
        XCTAssertEqual(emptyIntArray, try applyRule(rule))
    }
  
    func testAccessingVariableWithArrayIndexPath() {
      let rule =
        """
        { "var" : "person.name.0" }
        """
      let data =
        """
        { "person" : { "name" : ["John", "Green"] } }
        """
        XCTAssertEqual("John", try applyRule(rule, to: data))
    }
}
