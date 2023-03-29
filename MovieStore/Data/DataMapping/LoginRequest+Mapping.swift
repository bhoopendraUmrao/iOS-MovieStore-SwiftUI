//
//  LoginRequest+Mapping.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 27/03/23.
//

import Foundation

struct LoginRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
    let username: String
    let password: String
    let requestToken: String
}
