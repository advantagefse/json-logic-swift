import XCTest

import JSONTests
import JsonLogicTests

var tests = [XCTestCaseEntry]()
tests += JSONTests.__allTests()
tests += JsonLogicTests.__allTests()

XCTMain(tests)
