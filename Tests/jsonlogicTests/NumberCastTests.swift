//
//  NumberCastTests.swift
//  jsonlogicTests
//
//  Created by Dino on 22/07/2019.
//

import XCTest
@testable import jsonlogic

class NumberCastTests: XCTestCase {

    func testCastNumericalString() {
        var rule =
        """
        { "num": ["0"] }
        """
        
        XCTAssertEqual(0, try applyRule(rule, to: nil), accuracy: 0.002)
        
        rule =
        """
        { "num": ["0.145"] }
        """
        
        XCTAssertEqual(0.145, try applyRule(rule, to: nil), accuracy: 0.002)

        rule =
        """
        { "num": ["3.14159"] }
        """
        
        XCTAssertEqual(Double.pi, try applyRule(rule, to: nil), accuracy: 0.002)
    }

}
