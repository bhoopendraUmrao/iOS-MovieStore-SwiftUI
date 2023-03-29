//
//  AppConfigurationContainer.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/22/23.
//

import Foundation
import SwiftUI
import SENetworking

final class AppConfiguration {
    lazy var apiKey: String = {
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
//            fatalError("ApiKey must not be empty in plist")
//        }
        return "278589381d20959f7c8f3a0e85fde13f"
    }()
    lazy var apiBaseURL: String = {
//        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
//            fatalError("ApiBaseURL must not be empty in plist")
//        }
        return "https://api.themoviedb.org"
    }()
    
    lazy var imagesBaseURL: String = {
//        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
//            fatalError("ApiBaseURL must not be empty in plist")
//        }
        return "https://image.tmdb.org/t/p"
    }()
}


final class AppConfigurationContainer: ObservableObject {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: AsyncDataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: ["api_key": appConfiguration.apiKey,
                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let apiDataNetwork = DefaultAsyncNetworkService(config: config)
        return DefaultAsyncDataTransferService(with: apiDataNetwork)
    }()
    
    @Published var isUserLoggedIn: Bool = false
    
    lazy var imageDataTransferService: AsyncDataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.imagesBaseURL)!)
        let imagesDataNetwork = DefaultAsyncNetworkService(config: config)
        return DefaultAsyncDataTransferService(with: imagesDataNetwork)
    }()
    
    init() {
        if  UserDefaults.standard.value(forKey: "token") != nil {
            isUserLoggedIn = true
        }
    }
    
    func setLoggedInToken(_ token: String, expireationDate: Date) {
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.setValue(expireationDate, forKey: "expire")
        isUserLoggedIn = true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "expire")
        isUserLoggedIn = false
    }
    
    // MARK: - DIContainers of scenes
    func makeMoviesSceneDIContainer() -> some View {
        let movieRepository = DefaultMovieRepository(dataTransferService: apiDataTransferService)
        let searchUseCase = DefaultSearchMovieUseCase(movieRepository: movieRepository)
        let viewModel = DefaultMovieListViewModel(searchMovieUseCase: searchUseCase)
        return MovieListView(viewModel: viewModel)
    }
    
    func makeTrendingScene() -> some View {
        let mediaRepo = DefaultMediaRepository(dataTransferService: apiDataTransferService)
        let trendingMediaUseCase = DefaultTrendingMediaUseCase(mediaRepository: mediaRepo)
        let viewModel = DefaultTrendingMediaViewModel(trendingMediauseCase: trendingMediaUseCase)
        return TrendingMediaView(viewModel: viewModel)
    }
    
    func makeMovieDetailScene(mediaID: Int) -> some View {
        let movieRepository = DefaultMovieRepository(dataTransferService: apiDataTransferService)
        let movieDetailuseCase = DefaultMovieDetailUseCase(movieRepository: movieRepository)
        let viewModel = DefaultMovieDetailViewModel(mediaId: mediaID, movieDetailUseCase: movieDetailuseCase)
        return MovieDetailView(movieId: Int32(mediaID), viewModel: viewModel)
    }
    
    func makeTvShowDetailScene(mediaID: Int) -> some View {
        let tvShowRepository = DefaultTvShowRepository(dataTransferService: apiDataTransferService)
        let tvShowDetailuseCase = DefaultTvShowDetailUseCase(tvShowRepository: tvShowRepository)
        let viewModel = DefaultTvShowDetailViewModel(mediaId: mediaID, tvShowDetailuseCase: tvShowDetailuseCase)
        return TvShowDetailView(viewModel: viewModel)
    }
    
    func makeLoginView() -> some View {
        let loginRepository = DefaultLoginRepository(dataTransferService: apiDataTransferService)
        let loginUseCase = DefaultLoginUseCase(loginRepository: loginRepository)
        let viewModel = DefaultLoginViewModel(loginUseCase: loginUseCase)
        return LoginView(loginViewModel: viewModel)
    }
    
}
