//
//  TvShowDetailUseCase.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/16/23.
//

import Foundation

protocol TvShowDetailUseCase {
    func getDetail(for mediaId: Int) async throws -> TvShowDetail?
    func getVideoList(mediaId: Int) async throws -> [Video]?
}


final class DefaultTvShowDetailUseCase: TvShowDetailUseCase {
    
    private let tvShowRepository: TVShowRepository
    
    init(tvShowRepository: TVShowRepository) {
        self.tvShowRepository = tvShowRepository
    }
    
    func getDetail(for mediaId: Int) async throws -> TvShowDetail? {
        return try await tvShowRepository.fetchTvShowDetail(tvShowId: mediaId)
    }
    
    func getVideoList(mediaId: Int) async throws -> [Video]? {
        return try await tvShowRepository.fetchVideoList(tvShowId: mediaId)
    }
}
