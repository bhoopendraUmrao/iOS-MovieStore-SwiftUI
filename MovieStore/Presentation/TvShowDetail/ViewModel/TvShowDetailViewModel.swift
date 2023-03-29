//
//  TvShowDetailViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/16/23.
//

import Foundation

protocol TvShowDetailViewModel: ObservableObject {
    var tvShowDetail: TvShowDetailItemViewModel? { get }
    var videoList: [Video] { get }
    
    func didFetch()
}

final class DefaultTvShowDetailViewModel: TvShowDetailViewModel {
    
    @Published var tvShowDetail: TvShowDetailItemViewModel? = nil
    
    @Published var videoList: [Video] = []
    
    private let tvShowDetailuseCase: TvShowDetailUseCase
    
    private let mediaId: Int
    
    init(mediaId: Int, tvShowDetailuseCase: TvShowDetailUseCase) {
        self.mediaId = mediaId
        self.tvShowDetailuseCase = tvShowDetailuseCase
    }
    
    func didFetch() {
        Task {
            do {
                guard let tvShowDetail = try await tvShowDetailuseCase.getDetail(for: mediaId) else { return }
                await MainActor.run { [tvShowDetail] in
                    self.tvShowDetail = .init(tvShowDetail: tvShowDetail)
                }
                
                guard let videoList = try await tvShowDetailuseCase.getVideoList(mediaId: mediaId) else { return }
                await MainActor.run { [videoList] in
                    self.videoList = videoList
                }
            }
        }
    }
}
