//
//  RoundingTests.swift
//  jsonlogicTests
//
//  Created by Dino on 22/07/2019.
//

import XCTest
@testable import jsonlogic

class RoundingTests: XCTestCase {

    func testRounding_noDecimals() {
        var rule =
        """
        { "rnd": [1.234, 0] }
        """
        
        XCTAssertEqual(1, try applyRule(rule, to: nil))
        
        rule =
        """
        { "rnd": [1.789, 0] }
        """
        
        XCTAssertEqual(2, try applyRule(rule, to: nil))
        
        rule =
        """
        { "rnd": [-0.7, 0] }
        """
        
        XCTAssertEqual(-1, try applyRule(rule, to: nil))
        
        rule =
        """
        { "rnd": [-0.4, 0] }
        """
        
        XCTAssertEqual(0, try applyRule(rule, to: nil))
    }

}
