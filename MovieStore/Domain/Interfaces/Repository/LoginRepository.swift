//
//  LoginRepository.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 27/03/23.
//

import Foundation

protocol LoginRepository {
    func getRequestToken() async throws -> RequestToken?
    func login(userName: String,
               password: String,
               requestToken: String) async throws -> RequestToken?
}
