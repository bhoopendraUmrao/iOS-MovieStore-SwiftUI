//
//  TokenResponse+Mapping.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 27/03/23.
//

import Foundation

struct TokenResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
    let success: Bool
    let expiresAt: String
    let requestToken: String
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension TokenResponse {
    func toDomain() -> RequestToken {
        .init(token: requestToken, expireAt: dateFormatter.date(from: expiresAt) ?? Date())
    }
}
