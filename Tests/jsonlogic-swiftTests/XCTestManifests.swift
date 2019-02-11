import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Arithmetic.allTests),
        testCase(JsonLogicTests.allTests),
        testCase(NotStrictEquals.allTests),
        testCase(GreaterThanTests.allTests),
        testCase(GreaterThanOrEqualTests.allTests),
        testCase(LessThanTests.allTests),
        testCase(LessThanOrEqualTests.allTests),
        testCase(BetweenTests.allTests)
    ]
}
#endif
