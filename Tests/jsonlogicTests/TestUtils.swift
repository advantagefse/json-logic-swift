//
//  File.swift
//  
//
//  Created by Christos Koninis on 3/18/21.
//

import XCTest

//Implementation that allows for throwing errors from error handler block
func _XCTAssertThrowsError<T>(_ expression: @autoclosure () throws -> T,
                              _ message: @autoclosure () -> String = "",
                              file: StaticString = #file,
                              line: UInt = #line,
                              _ errorHandler: (_ error: Swift.Error) throws -> Void) rethrows {

    var iError: Error?
    XCTAssertThrowsError(try expression(), message(), file: file, line: line, { aError in
        iError = aError
    })

    if let iError = iError {
        try errorHandler(iError)
    }
}
