import XCTest
//import SwiftCheck

@testable import jsonlogic_swift

//swiftlint : disable force_try
final class JsonLogicTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testEqualsWithTwoSameConstants() {
        let rule =
        """
            { "===" : [1, 1] }
        """

        guard let result: Bool = try? jsonLogic.applyRule(rule, to: nil) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertTrue(result)
    }

    func testEqualsWithDifferentSameConstants() {
        let rule =
        """
            { "===" : [1, 2] }
        """
        let expectedResult = false

        guard let result: Bool = try? jsonLogic.applyRule(rule, to: nil) else {
                XCTFail("The data should be parsed correctly")
                return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testSetOneStringVariableFromData() {
        let rule =
        """
            { "var" : "a" }
        """
        let data =
        """
            { "a" : "1" }
        """
        let expectedResult = "1"

        guard let result: String = try? jsonLogic.applyRule(rule, to: data) else {
                XCTFail("The data should be parsed correctly")
                return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testSetOneIntegerVariableFromData() {
        let rule =
        """
            { "var" : "a" }
        """
        let data =
        """
            { "a" : 1 }
        """
        let expectedResult = 1

        guard let result: Int = try? jsonLogic.applyRule(rule, to: data) else {
                XCTFail("The data should be parsed correctly")
                return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testSetOneBoolVariableFromData() {
        let rule =
        """
            { "var" : "a" }
        """
        let data =
        """
            { "a" : true }
        """
        let expectedResult = true

        guard let result: Bool = try? jsonLogic.applyRule(rule, to: data) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testSetTwoStringVariablesFromData() {
        let rule =
        """
            { "var" : "a" }
        """
        let data =
        """
            { "a" : true }
        """
        let expectedResult = true

        guard let result: Bool = try? jsonLogic.applyRule(rule, to: data) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testSetOneStringNestedVariableFromData() {
        let rule =
        """
            { "var" : "person.name" }
        """
        let data =
        """
            { "person" : { "name" : "Jon" } }
        """
        let expectedResult = "Jon"

        guard let result: String = try? jsonLogic.applyRule(rule, to: data) else {
                XCTFail("The data should be parsed correctly")
                return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testSetOneStringArrayVariableFromData() {
        let rule =
        """
            { "var" : ["a"] }
        """
        let data =
        """
            { "a" : "1" }
        """
        let expectedResult = "1"

        guard let result: String = try? jsonLogic.applyRule(rule, to: data) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testAddTwoIntsFromVariables() {
        let rule =
        """
            { "===" : [{ "var" : ["a"] }, "1"] }
        """
        let data =
        """
            { "a" : "1" }
        """
        let expectedResult = true

        guard let result: Bool = try? jsonLogic.applyRule(rule, to: data) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testNestedVar() {
        let rule =
        """
            { "var" : [{ "var" : ["a"] }] }
        """
        let data =
        """
            { "a" : "b", "b" : "1" }
        """
        let expectedResult = "1"

        guard let result: String = try? jsonLogic.applyRule(rule, to: data) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testNestedVarWithStrictEquals() {
        let rule =
        """
            { "===" : [ {"var" : [ {"var" : ["a"]} ] }, {"var" : ["oneNest.one"]}] }
        """
        let data =
        """
            { "a" : "b", "b" : "1", "oneNest" : {"one" : "1"} }
        """
        let expectedResult = true

        guard let result: Bool = try? jsonLogic.applyRule(rule, to: data) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testNestedStrictEqualsWithVar() {
        let rule =
        """
            { "var" : [ {"var" : [ {"var" : ["a"] } ] } ] }
        """
        let data =
        """
            { "a" : "b", "b" : "oneNest.one", "oneNest" : {"one" : "10"} }
        """
        let expectedResult = "10"

        guard let result: String = try? jsonLogic.applyRule(rule, to: data) else {
            XCTFail("The data should be parsed correctly")
            return
        }

        XCTAssertEqual(expectedResult, result)
    }

    func testNotSupportedResultType() {
        let rule =
        """
            { "===" : [1, 1] }
        """

        class SomeType {}

        XCTAssertThrowsError(try { try jsonLogic.applyRule(rule) as SomeType }(), "") {
            //swiftlint:disable:next force_cast
            XCTAssertEqual($0 as! JSONLogicError, .canNotConvertResultToType(SomeType.self))
        }
    }

    static var allTests = [
        ("testEqualsWithTwoSameConstants", testEqualsWithTwoSameConstants),
        ("testEqualsWithDifferentSameConstants", testEqualsWithDifferentSameConstants),
        ("testSetOneIntegerVariableFromData", testSetOneIntegerVariableFromData),
        ("testSetOneStringVariableFromData", testSetOneStringVariableFromData),
        ("testSetOneStringNestedVariableFromData", testSetOneStringNestedVariableFromData),
        ("testAddTwoIntsFromVariables", testAddTwoIntsFromVariables),
        ("testNestedVar", testNestedVar),
        ("testNestedVarWithStrictEquals", testNestedVarWithStrictEquals),
        ("testNestedStrictEqualsWithVar", testNestedStrictEqualsWithVar),
        ("testNotSupportedResultType", testNotSupportedResultType)
    ]
}
