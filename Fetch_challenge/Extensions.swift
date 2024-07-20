//
//  Extensions.swift
//  Fetch_challenge
//
//  Created by Reed Gantz on 7/19/24.
//

import Foundation

extension String {
    /// Trims leading and trailing whitespace and newlines from the string.
    /// - Returns: A new string without leading and trailing whitespace and newlines.
    func trimWhitespace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Removes all carriage return characters and ensures only double newlines are used.
    /// - Returns: A new string with all carriage returns removed and single or multiple newlines converted to double newlines.
    func normalizeNewlines() -> String {
        // Remove all carriage returns
        let withoutCarriageReturns = self.replacingOccurrences(of: "\r", with: "")
        // Double all newlines
        let doubledNewlines = withoutCarriageReturns.replacingOccurrences(of: "\n", with: "\n\n")
        // Replace all occurrences of more than two newlines with exactly two newlines
        let pattern = "\n{3,}"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: doubledNewlines.utf16.count)
        let normalized = regex?.stringByReplacingMatches(in: doubledNewlines, options: [], range: range, withTemplate: "\n\n") ?? doubledNewlines
        return normalized
    }
}

extension URL {
    var youtubeID: String? {
        return URLComponents(string: self.absoluteString)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
}
