//
//  LoginViewModel.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 27/03/23.
//

import Foundation

protocol LoginViewModel {
    func requestLogin(userName: String, password: String) async -> RequestToken?
}

final class DefaultLoginViewModel: LoginViewModel {
    private var loginUseCase: LoginUseCase
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    @MainActor
    func requestLogin(userName: String, password: String) async -> RequestToken? {
        do {
            guard let token = try await loginUseCase.getRequestToken()?.token else {
                return nil
            }
            guard let loginToken = try await loginUseCase.login(query: .init(username: userName,
                                                                             password: password,
                                                                             requestToken: token)) else {
                return nil
            }
            return loginToken
        } catch {
            return nil
        }
        
    }
}
