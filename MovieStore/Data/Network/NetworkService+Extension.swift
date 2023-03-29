//
//  NetworkService+Extension.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/29/23.
//

import Foundation
import SENetworking

protocol AsyncNetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    typealias NetworkResult = Result<Data?, NetworkError>
    func request(endpoint: Requestable) async throws -> NetworkResult?
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

final class DefaultAsyncNetworkService: AsyncNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
                logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
    
        logger.log(request: request)

        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultAsyncNetworkService {
    func request(endpoint: Requestable) async throws -> NetworkResult? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            let result = await withCheckedContinuation { continuation in
                _ = request(request: urlRequest, completion: { result in
                    continuation.resume(returning: result)
                })
            }
            return result
        } catch {
            throw error
        }
    }
}

extension DefaultAsyncNetworkService {
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}
