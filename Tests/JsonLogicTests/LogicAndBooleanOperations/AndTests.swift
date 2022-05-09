//
//  AndTests.swift
//  JsonLogicTests
//
//  Created by Christos Koninis on 12/02/2019.
//

import XCTest
import JSON
@testable import JsonLogic

class AndTests: XCTestCase {

    func testAnd_twoBooleans() {
        
        XCTAssertNil(try applyRule("""
                                                  {"and": [null, true]}
                                                  """, to: nil))
        
        XCTAssertEqual(true, try applyRule("""
                                                  {"and": [true, true]}
                                                  """, to: nil))

        XCTAssertEqual(false, try applyRule("""
                                                    { "and" : [true, false] }
                                                    """, to: nil))

        XCTAssertEqual(true, try applyRule("""
                                                   { "and" : [true] }
                                                   """, to: nil))
        XCTAssertEqual(false, try applyRule("""
                                                      { "and" : [false] }
                                                     """, to: nil))
    }

    func testAnd_mixedArguments() {
        XCTAssertEqual(3, try applyRule("""
                { "and": [1, 3] }
                """, to: nil))

        XCTAssertEqual("a", try applyRule("""
                { "and": ["a"] }
                """, to: nil))

        XCTAssertEqual("", try applyRule("""
                { "and": [true,"",3] }
                """, to: nil))
    }
}
