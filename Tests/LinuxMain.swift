import XCTest

import JSONTests
import jsonlogicTests

var tests = [XCTestCaseEntry]()
tests += JSONTests.__allTests()
tests += jsonlogicTests.__allTests()

XCTMain(tests)
