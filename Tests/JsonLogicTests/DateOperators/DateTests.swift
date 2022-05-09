//
//  File.swift
//  
//
//  Created by Steffen on 24.06.21.
//

import Foundation
import XCTest
@testable import JsonLogic

final class DateTests:XCTestCase
{
    func testBefore()
    {
        let rule = """
        {"before": ["2019-05-22T21:11:28.970Z", "2019-05-25T21:11:28.970Z"]}
        """
        XCTAssertTrue(try applyRule(rule, to: nil))
    }
    
    func testAfter()
    {
        let rule = """
        {"after": ["2019-05-25T21:11:28.970Z", "2019-05-22T21:11:28.970Z"]}
        """
        XCTAssertTrue(try applyRule(rule, to: nil))
    }
    
    func testNotAfter()
    {
        let rule = """
        {"not-after": ["2019-05-22T21:11:28.970Z", "2019-05-25T21:11:28.970Z"]}
        """
        XCTAssertTrue(try applyRule(rule, to: nil))
    }
    
    func testNotBefore()
    {
        let rule = """
        {"not-before": ["2019-05-22T21:11:29.970Z", "2019-05-22T21:11:28.970Z"]}
        """
        XCTAssertTrue(try applyRule(rule, to: nil))
    }
    
}

