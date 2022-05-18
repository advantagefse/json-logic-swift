//
//  Date+ISO.swift
//  
//
//  Created by Igor Khomiak on 09.05.2022.
//

import Foundation

extension Date {
    static var nonFractalISO8601Formatter: ISO8601DateFormatter = {
      return ISO8601DateFormatter()
    }()

     static var fractionalISO8601DateFormatter: ISO8601DateFormatter {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return formatter
    }
    
    init?(dateISO8601String dateStr: String) {
        // An ISO 8601 date needs to at least contain dashes
        // If the string does not have a minimum length and contain any dashes
        // we can avoid the costly date parsing
        guard dateStr.count >= 10, dateStr.contains("-") else { return nil }
        
        // Try to parse without fractional seconds
        if let date = Date.nonFractalISO8601Formatter.date(from: dateStr) {
            self = date
            return
            
        } else if let date = Date.fractionalISO8601DateFormatter.date(from: dateStr) {
            self = date
            return
            
        } else if let date = Date.nonFractalISO8601Formatter.date(from: dateStr + "Z") {
            self = date
            return
            
        } else if let date = Date.fractionalISO8601DateFormatter.date(from: dateStr + "Z") {
            self = date
            return  // Try to parse without fractional seconds, try adding UTC timezone
            
        } else {
            return nil
        }
    }
    
    static var shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    public init?(dateFromShortFormatString str: String?) {
        guard let str = str else { return nil }
        // Since we use a DateFormatter with a fixed format we only need
        // to attempt parsing a date when we have a string with the exact length
        let trimmedString = str.trimmingCharacters(in: .whitespaces)
        guard trimmedString.count == 10 else { return nil }
        // and additionally if the fifth character is a dash
        guard trimmedString[trimmedString.index(str.startIndex, offsetBy: 4)] == "-"
        else { return nil }

        if let date = Date.shortFormatter.date(from: str) {
            self = date
        } else {
            return nil
        }
    }
}
