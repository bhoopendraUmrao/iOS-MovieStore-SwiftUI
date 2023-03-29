//
//  DataTransferService+Extension.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/29/23.
//

import Foundation
import SENetworking

protocol AsyncDataTransferService {
    typealias DataTransferResult<T> = Result<T, DataTransferError>
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> DataTransferResult<T>? where E.Response == T
    
    @discardableResult
    func request<E: ResponseRequestable>(with endpoint: E) async throws -> DataTransferResult<Void>? where E.Response == Void
}


final class DefaultAsyncDataTransferService: AsyncDataTransferService {
    
    private let networkService: AsyncNetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger

    public init(with networkService: AsyncNetworkService,
                errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
                errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
    
    public func request<T, E>(with endpoint: E) async throws -> DataTransferResult<T>? where T : Decodable,
                                                                                             T == E.Response,
                                                                                             E : ResponseRequestable {
        do {
            let result = try await self.networkService.request(endpoint: endpoint)
            switch result {
            case .success(let data):
                let result:Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                return result
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                throw error
            case .none:
                throw NetworkError.urlGeneration
            }
        }
    }
    
    public func request<E>(with endpoint: E) async throws -> DataTransferResult<Void>? where E : ResponseRequestable,
                                                                                             E.Response == Void {
        do {
            let result = try await self.networkService.request(endpoint: endpoint)
            switch result {
            case .success:
                return .success(())
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                throw error
            case .none:
                throw NetworkError.urlGeneration
            }
        }
    }
    
    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}
