//
//  SearchMovieUseCase.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/21/23.
//

import Foundation

protocol SearchMediaUseCase {
    func search(query: SearchMediaUseCaseRequestValue) async throws -> MediaPage?
}

struct SearchMediaUseCaseRequestValue {
    let query: MediaQuery
    let page: Int
}

final class DefaultSearchMovieUseCase: SearchMediaUseCase {
    
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func search(query: SearchMediaUseCaseRequestValue) async throws -> MediaPage? {
        return try await movieRepository.fetchMovieList(query: query.query, page: query.page)
    }
}
