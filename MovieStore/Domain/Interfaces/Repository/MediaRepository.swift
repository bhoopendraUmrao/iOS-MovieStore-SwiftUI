//
//  MediaRepository.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

protocol MediaRepository {
    func fetchTrendingList(for mediaType: MediaTrendingType, timeWindow: MediaTrendingTime, page: Int?) async throws -> MediaPage?
    func searchMedia(query: MediaQuery, page: Int) async throws -> MediaPage?
}
