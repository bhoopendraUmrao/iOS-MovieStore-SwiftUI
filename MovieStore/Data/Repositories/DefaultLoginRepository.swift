//
//  DefaultLoginRepositoy.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 27/03/23.
//

import Foundation

final class DefaultLoginRepository: LoginRepository {
    
    private let dataTransferService: AsyncDataTransferService
    
    init(dataTransferService: AsyncDataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func getRequestToken() async throws -> RequestToken? {
        let endpoint = APIEndpoints.Auth<TokenResponse>.requestToken.endpoint()
        return try? await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
    
    func login(userName: String,
               password: String,
               requestToken: String) async throws -> RequestToken? {
        let endpoint = APIEndpoints.Auth<TokenResponse>
            .login(request: .init(username: userName,
                                  password: password,
                                  requestToken: requestToken))
            .endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
}
