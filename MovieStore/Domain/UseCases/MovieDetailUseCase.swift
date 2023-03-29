//
//  MovieDetailUseCase.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/2/23.
//

import Foundation

protocol MovieDetailUseCase {
    func getDetail(for mediaId: Int) async throws -> MovieDetail?
    func getVideoList(mediaId: Int) async throws -> [Video]?
    func getCastList(mediaId: Int) async throws -> [CharacterCast]?
}

final class DefaultMovieDetailUseCase: MovieDetailUseCase {
    
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func getDetail(for mediaId: Int) async throws -> MovieDetail? {
        return try await movieRepository.fetchMovieDetail(movieId: mediaId)
    }
    
    func getVideoList(mediaId: Int) async throws -> [Video]? {
        return try await movieRepository.fetchVideoList(movieId: mediaId)
    }
    
    func getCastList(mediaId: Int) async throws -> [CharacterCast]? {
        return try await movieRepository.fetchCastList(movieId: mediaId)
    }
}
