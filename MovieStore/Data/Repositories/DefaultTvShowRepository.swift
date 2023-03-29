//
//  DefaultTvShowRepository.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/16/23.
//

import Foundation

final class DefaultTvShowRepository: TVShowRepository {
    
    private let dataTransferService: AsyncDataTransferService
    
    init(dataTransferService: AsyncDataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func fetchVideoList(tvShowId id: Int) async throws -> [Video]? {
        let endpoint = APIEndpoints.TvShow<MediaVideoResponse>.videos(id: id).endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
    
    func fetchTvShowList(query: MediaQuery, page: Int) async throws -> MediaPage? {
        let endpoint = APIEndpoints.Media<DefaultMediaResponse>
            .search(query: .init(query: query.query, page: page))
            .endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
    
    func fetchTvShowDetail(tvShowId: Int) async throws -> TvShowDetail? {
        let endpoint = APIEndpoints.TvShow<TvShowDetailResponse>.detail(id: tvShowId).endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
}
