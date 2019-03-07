//
//  IfTests.swift
//  jsonlogicTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonlogic

//swiftlint:disable function_body_length
class MissingTests: XCTestCase {

    let jsonLogic = JsonLogic()
    let emptyStringArray = [String]()

    func testVar_withEmptyVarName() {
        let rule =
                """
                {"var":[""]}
                """
        let data =
                """
                [1, 2, 3]
                """
        XCTAssertEqual([1, 2, 3], try jsonLogic.applyRule(rule, to: data))
    }

    func testMissing() {
        var rule =
        """
        {"missing":["a", "b"]}
        """
        var data =
        """
        {"a":"apple", "c":"carrot"}
        """
        XCTAssertEqual(["b"], try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a", "b"]}
        """
        data =
        """
        {"a":"apple", "b":"banana"}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":[]}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"missing":["a"]}
        """
        XCTAssertEqual(["a"], try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"missing":"a"}
        """
        XCTAssertEqual(["a"], try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"missing":"a"}
        """
        data =
        """
        {"a":"apple"}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a"]}
        """
        data =
        """
        {"a":"apple"}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a","b"]}
        """
        data =
        """
        {"a":"apple"}
        """
        XCTAssertEqual(["b"], try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a","b"]}
        """
        data =
        """
        {"b":"banana"}
        """
        XCTAssertEqual(["a"], try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a","b"]}
        """
        data =
        """
        {"a":"apple", "b":"banana"}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a","b"]}
        """
        data =
        """
        {}
        """
        XCTAssertEqual(["a", "b"], try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a","b"]}
        """
        XCTAssertEqual(["a", "b"], try jsonLogic.applyRule(rule, to: nil))
    }

    func testMissing_NestedKeys() {
        var rule =
        """
        {"missing":["a.b"]}
        """
        var data =
        """
        {"a":"apple"}
        """
        XCTAssertEqual(["a.b"], try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a.b"]}
        """
        XCTAssertEqual(["a.b"], try jsonLogic.applyRule(rule, to: nil))

        rule =
        """
        {"missing":["a.b"]}
        """
        data =
        """
        {"a":{"c":"apple cake"}}
        """
        XCTAssertEqual(["a.b"], try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a.b"]}
        """
        data =
        """
        {"a":{"b":"apple brownie"}}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing":["a.b", "a.c"]}
        """
        data =
        """
        {"a":{"b":"apple brownie"}}
        """
        XCTAssertEqual(["a.c"], try jsonLogic.applyRule(rule, to: data))
    }

    func testMissing_some() {
        var rule =
        """
        {"missing_some":[1, ["a", "b"]]}
        """
        var data =
        """
        {"a":"apple"}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing_some":[1, ["a", "b"]]}
        """
        data =
        """
        {"b":"banana"}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))

        rule =
        """
        {"missing_some":[1, ["a", "b"]]}
        """
        data =
        """
        {"b":"banana"}
        """
        XCTAssertEqual(emptyStringArray, try jsonLogic.applyRule(rule, to: data))
    }

    static var allTests = [
        ("testMissing", testMissing),
        ("testMissing_NestedKeys", testMissing_NestedKeys),
        ("testMissing_some", testMissing_some)
    ]
}
