//
//  LoginUseCase.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 27/03/23.
//

import Foundation

protocol LoginUseCase {
    func getRequestToken() async throws -> RequestToken?
    func login(query: LoginQuery) async throws -> RequestToken?
}


final class DefaultLoginUseCase: LoginUseCase {
    
    private let loginRepository: LoginRepository
    
    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
    
    func getRequestToken() async throws -> RequestToken? {
        try await loginRepository.getRequestToken()
    }
    
    func login(query: LoginQuery) async throws -> RequestToken? {
        try await loginRepository.login(userName: query.username,
                                        password: query.password,
                                        requestToken: query.requestToken)
    }
}
