//
//  APIHelpers.swift
//  Fetch_challenge
//
//  Created by Reed Gantz on 7/20/24.
//

import Foundation

public func isYouTubeVideoAvailable(urlString: String) async -> Bool {
    guard let url = URL(string: "https://www.youtube.com/oembed?url=\(urlString)&format=json") else {
        return false
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return true
        } else {
            return false
        }
    } catch {
        return false
    }
}
