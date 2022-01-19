// Copyright (c) 2021 Patrick Amrein <amrein@ubique.ch>
// 
// Licensed under LGPL


import Foundation

extension Date {

    static var nonFractalISO8601Formatter: ISO8601DateFormatter = {
      return ISO8601DateFormatter()
    }()

    static var fractalISO8601Formatter: ISO8601DateFormatter = {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return formatter
    }()

    static func fromISO8601(_ dateString: String) -> Date? {
        // An ISO 8601 date needs to at least contain dashes
        // If the string does not have a minimum length and contain any dashes
        // we can avoid the costly date parsing
        guard dateString.count >= 10 else { return nil }
        guard dateString.contains("-") else { return nil }
        
        // `ISO8601DateFormatter` does not support fractional zeros if not
        // configured (`.withFractionalSeconds`) and if configured, does not
        // parse dates without fractional seconds.

        // Try to parse without fractional seconds
        if let d = Date.nonFractalISO8601Formatter.date(from: dateString) {
            return d
        }

        // Retry with fraction
        if let d = Date.fractalISO8601Formatter.date(from: dateString) {
            return d
        }

        // nothing worked, try adding UTC timezone

        // Try to parse without fractional seconds
        if let d = Date.nonFractalISO8601Formatter.date(from: dateString + "Z") {
            return d
        }

        if let d = Date.fractalISO8601Formatter.date(from: dateString + "Z") {
            return d
        }
        return nil
    }
}
