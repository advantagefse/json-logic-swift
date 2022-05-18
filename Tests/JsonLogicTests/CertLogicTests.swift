//
//  CertLogic.swift
//
//
//  Created by Steffen on 22.06.21.
//

import Foundation
import XCTest
import JSON

@testable import JsonLogic


final class CertLogic: XCTestCase {
    
    func testEmptyData()
    {
        XCTAssertFalse(try applyRule("{}"))
    }
    
    func testCertLogic() {
        

        let fm = FileManager.default
        let path =  Bundle.main.resourcePath! + "/eu-dcc-business-rules/certlogic/specification/testSuite"
        var _ = ""
        do {
            let rulefiles = fm.enumerator(atPath: path)
            while let rulefile = rulefiles?.nextObject() {
               let rPath = rulefile as! String
               let jsonPath = path + "/" + rPath
               let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
               let json = JSON.init(data)
                
               let cases = json["cases"].array
                
                let skip = json["directive"]
                
                if( skip != "skip")
                {
                
                for c in cases!.enumerated() {
                    
                    let asserts = c.element["assertions"].array;
                    let name = c.element["name"].string!
                    var counter = 0;
                    for a in asserts!.enumerated() {
                        counter = counter + 1
                        print(name + " Assertion : \(counter)")
                        _ = a.element["certLogicExpression"]
                        let clogic = c.element["certLogicExpression"]
              
                        if(clogic.truthy())
                        {
                            let expectedType = a.element["expected"].type
                            
                            switch expectedType {
                            case JSON.ContentType.string:
                                XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),a.element["expected"].string)
                            case JSON.ContentType.bool:
                                XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),a.element["expected"].bool)
                            case JSON.ContentType.null:
                                XCTAssertNil(try applyRule(c.element["certLogicExpression"],to: a.element["data"]))
                            case JSON.ContentType.object:
                                    switch name {
                                        case "should work as binary operator":
                                                XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),a.element["expected"].dictionary)
                                    case "should return data context on \"\"":
                                                XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),["foo": "bar"])
                                    default:   XCTAssertFalse(true)
                                }
                            case JSON.ContentType.number:
                                switch name {
                                case "should drill into data (1)":
                                    XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),1)
                                case "should drill into data (2)":
                                    XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),1)
                                case "should drill into data (3)":
                                    XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),1)
                                case "var-ing non-existing array elements":
                                    XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),2)
                                case "should return first falsy operand":
                                    XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),0)
                                case "should return last truthy operand":
                                    XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),1)
                                default:
                                    XCTAssertFalse(true)
                                }
                            case JSON.ContentType.array:
                                XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),a.element["expected"])
                            default:
                                XCTAssertEqual(try applyRule(c.element["certLogicExpression"],to: a.element["data"]),a.element["expected"])
                            }
                        }
                        else
                        {
                          
                            let expectedType = a.element["expected"].type
                            
                            switch expectedType {
                            case JSON.ContentType.string:
                                XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),a.element["expected"].string)
                            case JSON.ContentType.bool:
                                XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),a.element["expected"].bool)
                            case JSON.ContentType.null:
                                XCTAssertNil(try applyRule(a.element["certLogicExpression"],to: a.element["data"]))
                            case JSON.ContentType.number:
                                switch name {
                                case "# Non-rules get passed through":
                                    XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),17)
                                case "# Single operator tests":
                                    XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),3)
                                case "Truthy and falsy definitions matter in Boolean operations":
                                    XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),0)
                                case "# Data-Driven":
                                    XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),1)
                                case "Filter, map, all, none, and some":
                                    if(a.element["expected"].int == 10 ){
                                        XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),10)
                                    }
                                    if(a.element["expected"].int == 0 ){
                                        XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),0)
                                    }
                                    if(a.element["expected"].int == 6 ){
                                        XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),6)
                                    }
                                default:
                                    XCTAssertFalse(true)
                                }
                           
                            case JSON.ContentType.array:
                                switch name {
                                case "# Non-rules get passed through":
                                  XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),["a","b"])
                                case "Truthy and falsy definitions matter in Boolean operations":
                                    XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),a.element["expected"].array)
                                case "Arrays with logic": do {
                                    if counter == 1 {
                                        XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),[1,2,3])
                                    }
                                    if counter == 2 {
                                        XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),[42])
                                    }
                                }
                                default:
                                    XCTAssertFalse(true)
                                }
                            default:
                                XCTAssertEqual(try applyRule(a.element["certLogicExpression"],to: a.element["data"]),a.element["expected"])
                            }
                      }
                    }
                  }
                }
                
            }
        } catch let e{
            print(e)
        }
    }
    
    func testRunner() {
        let fm = FileManager.default
        let path =  Bundle.main.resourcePath! + "/dgc-business-rules-testdata"
        var output = "";
        do {
            let rulefiles = fm.enumerator(atPath: path)
            while let rulefile = rulefiles?.nextObject() {
      
                let rulepath = rulefile as? NSString
                output = rulepath! as String
                if (rulepath?.contains("rule.json") == true)
                {
                    let rpath = rulepath! as String
                    let jsonpath =  path + "/" + rpath
                    let data = try Data(contentsOf: URL(fileURLWithPath: jsonpath), options: .mappedIfSafe)
                    let json = JSON.init(data)
                    
                    let components = rulepath!.pathComponents
                    
                    let testfpath=path + "/" + components[0] + "/" + components[1] + "/tests"
                    let testfiles = fm.enumerator(atPath: testfpath)
                    
                    while let testfile = testfiles?.nextObject() {
                        let testpath = testfile as? NSString
                        let tpath = testpath! as String
                        let tjsonpath =  testfpath + "/" + tpath
                        let tdata = try Data(contentsOf: URL(fileURLWithPath: tjsonpath), options: .mappedIfSafe)
                        let tjson = JSON.init(tdata)
                        let expectedValue = tjson["expected"].bool
                        
                        if(expectedValue != nil)
                        {
                          print("Test " + tjsonpath)
                          if(expectedValue.unsafelyUnwrapped)
                          {
                            XCTAssertTrue(try applyRule(json["Logic"], to: tjson))
                          }
                          else
                          {
                            XCTAssertFalse(try applyRule(json["Logic"], to: tjson))
                            
                          }
                        }
                    }
                }
            }
            print(output)
        } catch let e{
            print(e)
        }
        
    }
}
