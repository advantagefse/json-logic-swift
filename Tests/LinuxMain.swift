import XCTest

import jsonlogicTests

var tests = [XCTestCaseEntry]()
tests += jsonlogicTests.__allTests()

XCTMain(tests)
