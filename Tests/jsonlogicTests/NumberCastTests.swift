//
//  NumberCastTests.swift
//  jsonlogicTests
//
//  Created by Dino on 22/07/2019.
//

import XCTest
import JSON
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
    
    func testCastInvalidString() {
        var rule =
        """
        { "num": ["Hello World"] }
        """
        
        XCTAssertEqual(JSON.Null, try applyRule(rule, to: nil))
        
        rule =
        """
        { "num": ["0.14AF"] }
        """
        
        XCTAssertEqual(JSON.Null, try applyRule(rule, to: nil))

        rule =
        """
        { "num": ["F0.14"] }
        """
        
        XCTAssertEqual(JSON.Null, try applyRule(rule, to: nil))
        
        rule =
        """
        { "num": ["0...14"] }
        """
        
        XCTAssertEqual(JSON.Null, try applyRule(rule, to: nil))
        
        rule =
        """
        { "num": ["2.1.4"] }
        """
        
        XCTAssertEqual(JSON.Null, try applyRule(rule, to: nil))
    }

}
