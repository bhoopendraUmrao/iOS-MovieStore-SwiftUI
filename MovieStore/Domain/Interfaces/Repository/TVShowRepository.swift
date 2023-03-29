//
//  TVShowRepository.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/16/23.
//

import Foundation

protocol TVShowRepository {
    func fetchTvShowList(query: MediaQuery, page: Int) async throws -> MediaPage?
    func fetchTvShowDetail(tvShowId: Int) async throws -> TvShowDetail?
    func fetchVideoList(tvShowId: Int) async throws -> [Video]?
}
