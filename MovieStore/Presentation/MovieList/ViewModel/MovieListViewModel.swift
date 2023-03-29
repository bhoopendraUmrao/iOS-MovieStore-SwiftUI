//
//  MovieListViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/22/23.
//

import Foundation
import Combine

protocol MovieListViewModel: ObservableObject {
    var movies: [MovieListitemViewModel] { get }
    var isLoading: Bool { get }
    
    func didSearch(query: String)
    func didLoadNextPage()
}

final class DefaultMovieListViewModel: MovieListViewModel {
    
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount }
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var query: String = ""
    private var pages: [MediaPage] = []
    
    @Published var movies: [MovieListitemViewModel] = []
    
    @Published var isLoading: Bool = false
    
    private let searchMovieUseCase: SearchMediaUseCase
    
    init(searchMovieUseCase: SearchMediaUseCase) {
        self.searchMovieUseCase = searchMovieUseCase
    }
    
    func didSearch(query: String) {
        self.query = query
        load(query: .init(query: query))
    }
    
    func didLoadNextPage() {
        guard hasMorePages, !isLoading else { return }
        load(query: .init(query: query))
    }
    
    private func load(query: MediaQuery) {
        isLoading = true
        
        let _ = Task.init {
            guard let moviePage = try await searchMovieUseCase.search(query: .init(query: query, page: nextPage)) else {  return }

            await MainActor.run { [moviePage] in
                append(moviesPage: moviePage)
                isLoading = false
            }
            
        }
    }
    
    private func append(moviesPage: MediaPage) {
        currentPage = moviesPage.page
        totalPageCount = moviesPage.totalPage

        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]

        movies = pages.movies.map(MovieListitemViewModel.init)
    }
}
