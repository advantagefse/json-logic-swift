//
//  File.swift
//  
//
//  Created by Christos Koninis on 3/17/21.
//

import Foundation
import XCTest
@testable import JSON

class JSONTests: XCTestCase {

    func testJSONEquality() {
        XCTAssertEqual(JSON(10.10), JSON(10.10))
        XCTAssertEqual(JSON(10), JSON(10))
        XCTAssertEqual(JSON(10.0), JSON(10))
        XCTAssertEqual(JSON(10), JSON(10.0))
        XCTAssertEqual(JSON(0), JSON(false))
        XCTAssertEqual(JSON(false), JSON(0))
        XCTAssertEqual(JSON(1), JSON(true))
        XCTAssertEqual(JSON(true), JSON(1))
        XCTAssertEqual(JSON("10.10"), JSON("10.10"))
        XCTAssertEqual(JSON(10.10), JSON("10.10"))
        XCTAssertEqual(JSON("10.10"), JSON(10.10))
        XCTAssertEqual(JSON(10), JSON("10.0"))
        XCTAssertEqual(JSON("10.0"), JSON(10))
        XCTAssertEqual(JSON(10), JSON("10"))
        XCTAssertEqual(JSON("10"), JSON(10))
        XCTAssertEqual(JSON(false), JSON(false))
        XCTAssertEqual(JSON(true), JSON(true))
        XCTAssertEqual(JSON([1, 2]), JSON([1, 2]))
        XCTAssertEqual(JSON(["123": [1, 2]]), JSON(["123": [1, 2]]))
        XCTAssertEqual(JSON([1, 2, 123]), JSON([1, 2.0, "123"]))
    }

    func testJSONInEquality() {
        XCTAssertNotEqual(JSON(10.10), JSON(10.20))
        XCTAssertNotEqual(JSON(11), JSON(10))
        XCTAssertNotEqual(JSON(10.1), JSON(10))
        XCTAssertNotEqual(JSON(10), JSON(10.1))
        XCTAssertNotEqual(JSON(0), JSON(true))
        XCTAssertNotEqual(JSON(true), JSON(0))
        XCTAssertNotEqual(JSON(1), JSON(false))
        XCTAssertNotEqual(JSON(false), JSON(1))
        XCTAssertNotEqual(JSON("10.10"), JSON("10.00"))
        XCTAssertNotEqual(JSON(10.10), JSON("10.00"))
        XCTAssertNotEqual(JSON("10.10"), JSON(10.0))
        XCTAssertNotEqual(JSON("a"), JSON("abc"))
        XCTAssertNotEqual(JSON(10.0), JSON("abc"))
        XCTAssertNotEqual(JSON("abc"), JSON(10.0))
        XCTAssertNotEqual(JSON(10), JSON("abc"))
        XCTAssertNotEqual(JSON("abc"), JSON(10))
        XCTAssertNotEqual(JSON(10), JSON("11"))
        XCTAssertNotEqual(JSON("11"), JSON(10))
        XCTAssertNotEqual(JSON(true), JSON(false))
        XCTAssertNotEqual(JSON(false), JSON(true))
        XCTAssertNotEqual(JSON([]), JSON(true))
        XCTAssertNotEqual(JSON([1, 2]), JSON([1, 2, 3]))
        XCTAssertNotEqual(JSON([1, 2, 123]), JSON([1, 2.0, false]))
    }

    func testJSONStrictEquality() {
        XCTAssertTrue(JSON(10.10) === JSON(10.10))
        XCTAssertTrue(JSON(11) === JSON(11))
        XCTAssertTrue(JSON(false) === JSON(false))
        XCTAssertTrue(JSON(true) === JSON(true))
        XCTAssertTrue(JSON("abc") === JSON("abc"))
        XCTAssertTrue(JSON("10.0") === JSON("10.0"))
        XCTAssertTrue(JSON([]) === JSON([]))
        XCTAssertTrue(JSON([1, 2]) === JSON([1, 2]))
        XCTAssertTrue(JSON([1, 2, "123"]) === JSON([1, 2, "123"]))
        XCTAssertTrue(JSON(["123": [1, 2]]) === JSON(["123": [1, 2]]))
    }

    func testJSONStrictInEquality() {
        XCTAssertTrue(JSON(10.0) !== JSON(10))
        XCTAssertTrue(JSON(10) !== JSON(10.0))
        XCTAssertTrue(JSON("10.10") !== JSON(10.10))
        XCTAssertTrue(JSON(10.10) !== JSON("10.10"))
        XCTAssertTrue(JSON(0) !== JSON(false))
        XCTAssertTrue(JSON(false) !== JSON(0))
        XCTAssertTrue(JSON(1) !== JSON(true))
        XCTAssertTrue(JSON(true) !== JSON(1))
        XCTAssertTrue(JSON(10.10) !== JSON(10.20))
        XCTAssertTrue(JSON(11) !== JSON(10))
        XCTAssertTrue(JSON(10.1) !== JSON(10))
        XCTAssertTrue(JSON(10) !== JSON(10.1))
        XCTAssertTrue(JSON(0) !== JSON(true))
        XCTAssertTrue(JSON(true) !== JSON(0))
        XCTAssertTrue(JSON(1) !== JSON(false))
        XCTAssertTrue(JSON(false) !== JSON(1))
        XCTAssertTrue(JSON("10.10") !== JSON("10.00"))
        XCTAssertTrue(JSON(10.10) !== JSON("10.00"))
        XCTAssertTrue(JSON("10.10") !== JSON(10.0))
        XCTAssertTrue(JSON("a") !== JSON("abc"))
        XCTAssertTrue(JSON(10.0) !== JSON("abc"))
        XCTAssertTrue(JSON("abc") !== JSON(10.0))
        XCTAssertTrue(JSON(10) !== JSON("abc"))
        XCTAssertTrue(JSON("abc") !== JSON(10))
        XCTAssertTrue(JSON(10) !== JSON("11"))
        XCTAssertTrue(JSON("11") !== JSON(10))
        XCTAssertTrue(JSON(true) !== JSON(false))
        XCTAssertTrue(JSON(false) !== JSON(true))
        XCTAssertTrue(JSON([]) !== JSON(true))
        XCTAssertTrue(JSON([1, 2]) !== JSON([1, 2, 3]))
        XCTAssertTrue(JSON([1, 2, 123]) !== JSON([1, 2.0, "123"]))
        XCTAssertTrue(JSON(["312": [1, 2], "123": [1, 2]])
                        !== JSON(["123": [1, 2], "312": [1, "2"]]))
        XCTAssertTrue(JSON(["123": [1, 2]]) !== JSON(["123": [1, "2"]]))
        XCTAssertTrue(JSON(["123": [1, 2]]) !== JSON(["123": [1, 2.0]]))
    }
}

