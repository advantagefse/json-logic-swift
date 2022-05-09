import XCTest
import JSON
@testable import JsonLogic

final class JsonLogicTests: XCTestCase {

    
    func testVarBasics()
    {
        let rule = """
                    {
                        "var": ""
                    }
                   """
        let data = """
                    {
                        "foo": "bar"
                    }
                   """
       
        
        XCTAssertEqual(try applyRule(rule, to: data),[ "foo": "bar"])
    }
    
    
    func testEmptyData() {
        let rule =
        """
            ["a", "b"]
        """

        let data = """
                        {}
                   """
        
        XCTAssertEqual(try applyRule(rule, to: data),["a","b"])
    }
    
    func testEqualsWithTwoSameConstants() {
        let rule =
        """
            { "===" : [1, 1] }
        """

        XCTAssertTrue(try applyRule(rule, to: nil))
    }

    func testEqualsWithDifferentSameConstants() {
        let rule =
        """
            { "===" : [1, 2] }
        """

        XCTAssertFalse(try applyRule(rule, to: nil))
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

        XCTAssertEqual("1", try applyRule(rule, to: data))
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

        XCTAssertEqual(1, try applyRule(rule, to: data))
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

        XCTAssertTrue(try applyRule(rule, to: data))
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

        XCTAssertTrue(try applyRule(rule, to: data))
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

        XCTAssertEqual("Jon", try applyRule(rule, to: data))
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

        XCTAssertEqual("1", try applyRule(rule, to: data))
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

        XCTAssertTrue(try applyRule(rule, to: data))
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

        XCTAssertEqual("1", try applyRule(rule, to: data))
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

        XCTAssertTrue(try applyRule(rule, to: data))
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

        XCTAssertEqual("10", try applyRule(rule, to: data))
    }

    func testNotSupportedResultType() {
        let rule =
        """
            { "===" : [1, 1] }
        """

        class SomeType {}

        XCTAssertThrowsError(try { try applyRule(rule) as SomeType }(), "") {
            //swiftlint:disable:next force_cast
            XCTAssertEqual($0 as! JSONLogicError, .canNotConvertResultToType(SomeType.self))
        }
    }
}
