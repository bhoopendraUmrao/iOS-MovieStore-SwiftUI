//
//  MovieDetailViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

protocol MovieDetailViewModel: ObservableObject {
    var movieDetail: MovieDetailItemViewModel? { get }
    var videoList: [Video] { get }
    var castList: [CharacterCast] { get }
    func didFetch()
}

final class DefaultMovieDetailViewModel: MovieDetailViewModel {
    
    @Published var movieDetail: MovieDetailItemViewModel? = nil
    
    @Published var videoList: [Video] = []
    
    @Published var castList: [CharacterCast] = []
    
    private let movieDetailuseCase: MovieDetailUseCase
    
    private let mediaId: Int
    
    init(mediaId: Int, movieDetailUseCase: MovieDetailUseCase) {
        self.mediaId = mediaId
        self.movieDetailuseCase = movieDetailUseCase
    }
    
    func didFetch() {
        Task {
            do {
                guard let movieDetail = try await movieDetailuseCase.getDetail(for: mediaId) else { return }
                await MainActor.run { [movieDetail] in
                    self.movieDetail = .init(movieDetail: movieDetail)
                }
                
                guard let videoList = try await movieDetailuseCase.getVideoList(mediaId: mediaId) else { return }
                await MainActor.run { [videoList] in
                    self.videoList = videoList
                }
                
                guard let casts = try await movieDetailuseCase.getCastList(mediaId: mediaId) else {
                    return
                }
                await MainActor.run { [casts] in
                    self.castList = casts
                }
            }
        }
    }
}
