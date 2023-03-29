//
//  DefaultMovieRepository.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/21/23.
//

import Foundation

final class DefaultMovieRepository: MovieRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func fetchMovieList(query: MediaQuery, page: Int) async throws -> MediaPage? {
        let movieRequest = MediaSearchRequest(query: query.query, page: page)
        let endpoint = APIEndpoints.searchMovies(with: movieRequest)
        return nil//try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
    
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail? {
        let endpoint = APIEndpoints.Movies<MovieDetailResponse>.detail(id: movieId).endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
    
    func fetchVideoList(movieId: Int) async throws -> [Video]? {
        let endpoint = APIEndpoints.Movies<MediaVideoResponse>.videos(id: movieId).endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
    
    func fetchCastList(movieId: Int) async throws -> [CharacterCast]? {
        let endpoint = APIEndpoints.Movies<MovieCreditResponse>.credits(id: movieId).endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
}
