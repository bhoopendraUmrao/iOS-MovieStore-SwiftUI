//
//  TrendingMediaViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

protocol TrendingMediaViewModel: ObservableObject {
    var mediaList: [MediaListItemViewModel] { get }
    var isLoading: Bool { get }
    var mediaFilters: [TrendingMediaFilterViewModel] { get set }
    
    func didFetch(for mediaType: MediaTrendingType, time: MediaTrendingTime)
    func reset()
    func search(text: String)
}

final class DefaultTrendingMediaViewModel: TrendingMediaViewModel {
    
    @Published var mediaList: [MediaListItemViewModel] = []
    
    @Published var isLoading: Bool = false
    
    var mediaFilters: [TrendingMediaFilterViewModel] = []
    
    private var trendingMediauseCase: TrendingMediaUseCase
    
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount }
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var pages: [MediaPage] = []
    
    init(trendingMediauseCase: TrendingMediaUseCase) {
        self.trendingMediauseCase = trendingMediauseCase
        setFilters()
    }
    
    private func setFilters() {
        mediaFilters.removeAll()
        mediaFilters.append(.init(title: "Type", filters: MediaTrendingType.allCases.compactMap{ $0.value }))
        mediaFilters.append(.init(title: "Time", filters: MediaTrendingTime.allCases.compactMap{ $0.value }))
    }
    
    func didFetch(for mediaType: MediaTrendingType, time: MediaTrendingTime) {
        isLoading = true
        Task {
            do {
                guard let mediaPage = try await trendingMediauseCase.fetchTrendingList(for: .init(mediaType: mediaType,
                                                                                                  timeWindow: time),
                                                                                       page: nextPage) else { return }
                await MainActor.run{ [mediaPage] in
                    append(moviesPage: mediaPage)
                }
            }
        }
    }
    
    func reset() {
        currentPage = 0
        totalPageCount = 1
        pages = []
    }
    
    func search(text: String) {
        isLoading = true
        Task {
            do {
                guard let mediaPage = try await trendingMediauseCase.search(query: .init(query: .init(query: text),
                                                                                         page: 1)) else {
                    return
                }
                
                await MainActor.run { [mediaPage] in
                    append(moviesPage: mediaPage)
                }
            }
        }
    }
    
    private func append(moviesPage: MediaPage) {
        currentPage = moviesPage.page
        totalPageCount = moviesPage.totalPage
        
        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]

        mediaList = pages.movies.map(MediaListItemViewModel.init)
    }
}
