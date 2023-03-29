//
//  MovieRepository.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/21/23.
//

import Foundation

protocol MovieRepository {
    func fetchMovieList(query: MediaQuery, page: Int) async throws -> MediaPage?
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail?
    func fetchVideoList(movieId: Int) async throws -> [Video]?
    func fetchCastList(movieId: Int) async throws -> [CharacterCast]? 
}
