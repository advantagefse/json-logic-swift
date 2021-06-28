// Copyright (c) 2021 Patrick Amrein <amrein@ubique.ch>
// 
// Licensed under LGPL


import Foundation

extension Date {
    static func fromISO8601(_ dateString: String) -> Date? {
        // `ISO8601DateFormatter` does not support fractional zeros if not
        // configured (`.withFractionalSeconds`) and if configured, does not
        // parse dates without fractional seconds.

        let formatter = ISO8601DateFormatter()

        // Try to parse without fractional seconds
        if let d = formatter.date(from: dateString) {
            return d
        }

        // Retry with fraction
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = formatter.date(from: dateString) {
            return d
        }

        // nothing worked, try adding UTC timezone

        let formatter_without_timezone = ISO8601DateFormatter()
        // Try to parse without fractional seconds
        if let d = formatter_without_timezone.date(from: dateString + "Z") {
            return d
        }

        formatter_without_timezone.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = formatter_without_timezone.date(from: dateString + "Z") {
            return d
        }
        return nil
    }
}
