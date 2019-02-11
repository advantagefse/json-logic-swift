//
//  AndTests.swift
//  jsonlogic-swiftTests
//
//  Created by Christos Koninis on 12/02/2019.
//

import XCTest

@testable import jsonlogic_swift

class AndTests: XCTestCase {

    let jsonLogic = JsonLogic()

    func testAnd_twoBooleans() {
        XCTAssertEqual(true, try jsonLogic.applyRule("""
                                                  {"and": [true, true]}
                                                  """, to: nil))

        XCTAssertEqual(false, try jsonLogic.applyRule("""
                                                    { "and" : [true, false] }
                                                    """, to: nil))

        XCTAssertEqual(true, try jsonLogic.applyRule("""
                                                   { "and" : [true] }
                                                   """, to: nil))
        XCTAssertEqual(false, try jsonLogic.applyRule("""
                                                      { "and" : [false] }
                                                     """, to: nil))
    }

    func testAnd_mixedArguments() {
        XCTAssertEqual(3, try jsonLogic.applyRule("""
                { "and": [1, 3] }
                """, to: nil))

        XCTAssertEqual("a", try jsonLogic.applyRule("""
                { "and": ["a"] }
                """, to: nil))

        XCTAssertEqual("", try jsonLogic.applyRule("""
                { "and": [true,"",3] }
                """, to: nil))
    }

    static var allTests = [
        ("testAnd_twoBooleans", testAnd_twoBooleans),
        ("testAnd_mixedArguments", testAnd_mixedArguments)
    ]
}
