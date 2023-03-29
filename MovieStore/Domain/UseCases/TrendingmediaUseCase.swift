//
//  TrendingmediaUseCase.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

protocol TrendingMediaUseCase: SearchMediaUseCase {
    func fetchTrendingList(for request: TrendingMediaUseCaseRequest, page: Int?) async throws -> MediaPage?
}

struct TrendingMediaUseCaseRequest {
    let mediaType: MediaTrendingType
    let timeWindow: MediaTrendingTime
}

final class DefaultTrendingMediaUseCase: TrendingMediaUseCase {

    private let mediaRepository: MediaRepository
    
    init(mediaRepository: MediaRepository) {
        self.mediaRepository = mediaRepository
    }
    
    func fetchTrendingList(for request: TrendingMediaUseCaseRequest, page: Int?) async throws -> MediaPage? {
        return try await mediaRepository.fetchTrendingList(for: request.mediaType, timeWindow: request.timeWindow, page: page)
    }
    
    func search(query: SearchMediaUseCaseRequestValue) async throws -> MediaPage? {
        return try await mediaRepository.searchMedia(query: query.query, page: query.page)
    }
}
