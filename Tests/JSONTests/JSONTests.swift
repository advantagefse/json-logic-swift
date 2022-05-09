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

    func testJSONAdd() {
        XCTAssertEqual(JSON(10.10) + JSON(10.10), JSON(20.20))
        XCTAssertEqual(JSON(10.10) + JSON(10), JSON(20.10))
        XCTAssertEqual(JSON(10) + JSON(10.10), JSON(20.10))
        XCTAssertEqual(JSON(10) + JSON("10.10"), JSON.Null)
    }

    func testJSONMinus() {
        XCTAssertEqual(-JSON(-10), JSON(10))
        XCTAssertEqual(-JSON(-10.0), JSON(10.0))
    }

    func testJSONMultiply() {
        XCTAssertEqual(JSON(10.0) * JSON(10.0), JSON(100.0))
        XCTAssertEqual(JSON(10) * JSON(10.0), JSON(100.0))
        XCTAssertEqual(JSON(10.0) * JSON(10), JSON(100.0))
        XCTAssertEqual(JSON(10) * JSON(10), JSON(100))
        XCTAssertEqual(JSON(10) * JSON("abc"), JSON.Null)
    }

    func testJSONMDivide() {
        XCTAssertEqual(JSON(10.0) / JSON(10.0), JSON(1.0))
        XCTAssertEqual(JSON(10) / JSON(10.0), JSON(1.0))
        XCTAssertEqual(JSON(10.0) / JSON(10), JSON(1.0))
        XCTAssertEqual(JSON(10) / JSON(10), JSON(1))
        XCTAssertEqual(JSON(10) / JSON("abc"), JSON.Null)
    }

    func testJSONMModulo() {
        XCTAssertEqual(JSON(101) % JSON(2), JSON(1))
        XCTAssertEqual(JSON(101.0) % JSON(2.0), JSON(1.0))
        XCTAssertEqual(JSON(101.0) % JSON(2.5), JSON(1.0))
        XCTAssertEqual(JSON(101.75) % JSON(2), JSON(1.75))
        XCTAssertEqual(JSON(101) % JSON(1.5), JSON(0.5))
        XCTAssertEqual(JSON(10) % JSON("abc"), JSON.Null)
    }

    func testJSONMLessThan() {
        XCTAssertTrue(JSON(10.0) < JSON(10.1))
        XCTAssertTrue(JSON(10) < JSON(11))
        XCTAssertTrue(JSON(10.0) < JSON(11))
        XCTAssertTrue(JSON(11) < JSON(12.0))
        XCTAssertTrue(JSON(11) < JSON("12.0"))
        XCTAssertTrue(JSON(11.0) < JSON("12.0"))
        XCTAssertTrue(JSON("11") < JSON(12.0))
        XCTAssertFalse(JSON("ABC") < JSON(12.0))
        XCTAssertTrue(JSON(false) < JSON(true))
        XCTAssertTrue(JSON([1,22]) < JSON([2,1]))
        XCTAssertFalse(JSON([1,22]) < JSON([]))
        XCTAssertFalse(JSON([]) < JSON([]))
    }

    func testJSONMInitializationFromValue() {
        XCTAssertEqual(JSON(10.0), JSON.Double(10.0))
        XCTAssertEqual(JSON("10.0"), JSON.String("10.0"))
        XCTAssertEqual(JSON(10), JSON.Int(10))
        XCTAssertEqual(JSON(true), JSON.Bool(true))
        XCTAssertEqual(JSON(nil), JSON.Null)

        XCTAssertEqual(JSON([1]), JSON.Array([JSON.Int(1)]))
        XCTAssertEqual(JSON([1, 1]), JSON.Array([JSON.Int(1), JSON.Int(1)]))
        XCTAssertEqual(JSON([1, 1, 2]), JSON.Array([JSON.Int(1), JSON.Int(1), JSON.Int(2)]))

        // This is differnt from how original JsonLogic JS implementation works
        // since it does not allow comparing dictionaries/arrays
        XCTAssertEqual(JSON(["1": 1]), JSON.Dictionary(["1": 1]))
    }


    func testJSONMInitializationFromLiteral() {
        var json: JSON = [1]
        XCTAssertEqual(json, JSON.Array([JSON.Int(1)]))

        json = ["1": 1]
        XCTAssertEqual(json, JSON.Dictionary(["1": 1]))

        json = 10.0
        XCTAssertEqual(json, JSON.Double(10.0))

        json = "10.0"
        XCTAssertEqual(json, JSON.String("10.0"))

        json = 10
        XCTAssertEqual(json, JSON.Int(10))

        json = true
        XCTAssertEqual(json, JSON.Bool(true))

        json = nil
        XCTAssertEqual(json, JSON.Null)
    }

    func testJSONSubscriptGet_GivenJSONArray() throws {
        let jsonInts = JSON.Array([3, 2, 1])

        XCTAssertEqual(jsonInts[0], 3)
        XCTAssertEqual(jsonInts[1], 2)
        XCTAssertEqual(jsonInts[2], 1)

        let jsonMixed = JSON.Array([.Bool(false), .String("123"), .Null])

        XCTAssertEqual(jsonMixed[0], false)
        XCTAssertEqual(jsonMixed[1], "123")
        XCTAssertEqual(jsonMixed[2], nil)


        let error: JSON.JSON2Error? = {
            if case let JSON.Error(error) = jsonInts[3] {
                return error
            }
            return nil
        }()
        XCTAssertEqual(error, .indexOutOfRange(3))
    }

    func testJSONSubscriptSet_GivenJSONArray() throws {
        var jsonInts = JSON.Array([3, 2, 1])

        jsonInts[0] = "123"
        jsonInts[1] = nil
        jsonInts[2] = 1.1
        XCTAssertEqual(jsonInts[0], "123")
        XCTAssertEqual(jsonInts[1], nil)
        XCTAssertEqual(jsonInts[2], 1.1)

        let error: JSON.JSON2Error? = {
            if case let JSON.Error(error) = jsonInts[3] {
                return error
            }
            return nil
        }()
        XCTAssertEqual(error, .indexOutOfRange(3))
    }

    func testJSONSubscriptSetPadsArrayWithNil_WhenIndexIsOutOfRange_GivenJSONArray() throws {
        var jsonInts = JSON.Array([3, 2, 1])

        jsonInts[8] = 0

        //It should pad the index with nil (JSON.Nil)
        XCTAssertEqual(jsonInts, JSON([3, 2, 1, nil, nil, nil, nil, nil, 0]))
    }

    func testJSONSubscriptGet_GivenJSONDictionary() throws {
        let jsonInts = JSON.Dictionary(["1": 1, "abc": 2])

        XCTAssertEqual(jsonInts["1"], 1)
        XCTAssertEqual(jsonInts["abc"], 2)

        let notSubscribableJSONType = JSON.Bool(true)

        let error: JSON.JSON2Error? = {
            if case let JSON.Error(error) = notSubscribableJSONType["abc"] {
                return error
            }
            return nil
        }()
        XCTAssertEqual(error, .notSubscriptableType(JSON.Bool(true).type))
    }

    func testJSONSubscriptSet_GivenJSONDictionary() throws {
        var jsonInts = JSON.Dictionary(["1": 1, "abc": 2])

        jsonInts["1"] = 123
        jsonInts["abc"] = false

        XCTAssertEqual(jsonInts["1"], 123)
        XCTAssertEqual(jsonInts["abc"], false)
    }

    func testTruthy() {
        //https://jsonlogic.com/truthy.html

        XCTAssertEqual(JSON.Int(0).truthy(), false)
        XCTAssertEqual(JSON.Int(1).truthy(), true)
        XCTAssertEqual(JSON.Int(-1).truthy(), true)
        XCTAssertEqual(JSON.Double(1.1).truthy(), true)

        XCTAssertEqual(JSON.Array([]).truthy(), false)
        XCTAssertEqual(JSON.Array([1, 2]).truthy(), true)

        XCTAssertEqual(JSON.String("").truthy(), false)
        XCTAssertEqual(JSON.String("abc").truthy(), true)
        XCTAssertEqual(JSON.String("0").truthy(), true)

        XCTAssertEqual(JSON.Null.truthy(), false)

        XCTAssertEqual(JSON.Bool(true).truthy(), true)
        XCTAssertEqual(JSON.Bool(false).truthy(), false)

        XCTAssertEqual(JSON.init(string: "{}")!.truthy(), false)
        XCTAssertEqual(JSON.Dictionary(["": 1]).truthy(), true)

        XCTAssertEqual(JSON.Error(.notJSONValue).truthy(), false)
    }

    func testToNumberConversion() {
        XCTAssertEqual(JSON.Int(0).toNumber(), JSON.Int(0))
        XCTAssertEqual(JSON.Double(1.1).toNumber(), JSON.Double(1.1))

        XCTAssertEqual(JSON.Bool(true).toNumber(), JSON.Int(1))
        XCTAssertEqual(JSON.Bool(false).toNumber(), JSON.Int(0))

        XCTAssertEqual(JSON.String("0").toNumber(), JSON.Int(0))
        XCTAssertEqual(JSON.String("1").toNumber(), JSON.Int(1))
        XCTAssertEqual(JSON.String("1.0").toNumber(), JSON.Int(1))
        XCTAssertEqual(JSON.String("1.0").toNumber(), JSON.Double(1.0))
        XCTAssertEqual(JSON.String("1.1").toNumber(), JSON.Double(1.1))

        XCTAssertEqual(JSON.String("1.1.").toNumber(), JSON.Null)
        XCTAssertEqual(JSON.Array([]).toNumber(), JSON.Null)
        XCTAssertEqual(JSON.Array([1, 2]).toNumber(), JSON.Null)
        XCTAssertEqual(JSON.Null.toNumber(), JSON.Null)
        XCTAssertEqual(JSON.init(string: "{}")!.toNumber(), JSON.Null)
        XCTAssertEqual(JSON.Dictionary(["": 1]).toNumber(), JSON.Null)
        XCTAssertEqual(JSON.Error(.notJSONValue).toNumber(), JSON.Null)
    }

    func testContentTypeConversion() {
        XCTAssertEqual(JSON.Int(0).type, JSON.ContentType.number)
        XCTAssertEqual(JSON.Double(1.1).type, JSON.ContentType.number)
        XCTAssertEqual(JSON.Bool(true).type, JSON.ContentType.bool)
        XCTAssertEqual(JSON.String("abc").type, JSON.ContentType.string)
        XCTAssertEqual(JSON.Array([]).type, JSON.ContentType.array)
        XCTAssertEqual(JSON.Array([1, 2]).type, JSON.ContentType.array)
        XCTAssertEqual(JSON.init(string: "{}")!.type, JSON.ContentType.object)
        XCTAssertEqual(JSON.Error(.notJSONValue).type, JSON.ContentType.error)
        XCTAssertEqual(JSON.Null.type, JSON.ContentType.null)
    }

    func testInitializationWithDefaultValue() {
        XCTAssertEqual(JSON(), JSON.Null)
    }

    func testInitializationWithInvalidValue() throws {
        class AClass {}

        let jsonInvalid = JSON(AClass())

        let error: JSON.JSON2Error? = {
            if case let JSON.Error(error) = jsonInvalid {
                return error
            }
            return nil
        }()

        let parseError = NSError(domain: "Can't convert value \(AClass()) to JSON", code: 1)
        XCTAssertEqual(error, .NSError(parseError))
    }
}

