//
//  Login.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 27/03/23.
//

import Foundation

struct RequestToken: Equatable {
    let token: String
    let expireAt: Date
}

struct LoginQuery: Equatable {
    let username: String
    let password: String
    let requestToken: String
}
