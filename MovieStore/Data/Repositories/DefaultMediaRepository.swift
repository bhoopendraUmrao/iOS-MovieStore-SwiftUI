//
//  DefaultMediaRepository.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

final class DefaultMediaRepository: MediaRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
 
    func fetchTrendingList(for mediaType: MediaTrendingType, timeWindow: MediaTrendingTime, page: Int?) async throws -> MediaPage? {
        switch mediaType {
//        case .person:
//            let endpoint = APIEndpoints.TrendingEndpoint<PeopleResponse>.people(timeWindow: timeWindow, page: page).endpoint()
//            return try await dataTransferService.request(with: endpoint)?.get().toDomain()
        case .movie:
            let endpoint = APIEndpoints.TrendingEndpoint<DefaultMediaResponse>.movies(timeWindow: timeWindow, page: page).endpoint()
            return try await dataTransferService.request(with: endpoint)?.get().toDomain()
        case .tv:
            let endpoint = APIEndpoints.TrendingEndpoint<DefaultMediaResponse>.tvShows(timeWindow: timeWindow, page: page).endpoint()
            return try await dataTransferService.request(with: endpoint)?.get().toDomain()
        
        }
    }
    
    func searchMedia(query: MediaQuery, page: Int) async throws -> MediaPage? {
        let endpoint = APIEndpoints.Media<DefaultMediaResponse>
            .search(query: .init(query: query.query, page: page))
            .endpoint()
        return try await dataTransferService.request(with: endpoint)?.get().toDomain()
    }
}
