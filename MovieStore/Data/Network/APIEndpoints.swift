//
//  APIEndpoints.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/22/23.
//

import Foundation

struct APIEndpoints {
    static func searchMovies(with queryRequest: MediaSearchRequest) -> Endpoint<MediaResponse> {
        return Endpoint(path: "3/search/movie",
                        method: .get,
                        queryParametersEncodable: queryRequest)
    }
    
    enum TrendingEndpoint<T: MediaResponse> {
        case movies(timeWindow: MediaTrendingTime = .day, page: Int? = nil)
        case tvShows(timeWindow: MediaTrendingTime = .day, page: Int? = nil)
        case people(timeWindow: MediaTrendingTime = .day, page: Int? = nil)
    }
    
    enum Movies<T> {
        case detail(id: Int)
        case videos(id: Int)
        case credits(id: Int)
    }
    
    enum TvShow<T> {
        case detail(id: Int)
        case videos(id: Int)
    }
    
    enum Media<T> {
        case search(query: MediaSearchRequest)
    }
    
    enum Auth<T> {
        case requestToken
        case login(request: LoginRequest)
    }
}

extension APIEndpoints.TrendingEndpoint {
    
    func endpoint() -> Endpoint<T>{
        switch self {
        case .movies(let timeWindow, let page):
            return Endpoint(path: "3/trending/movie".appending("/\(timeWindow.rawValue)"),
                                     method: .get,
                                     queryParametersEncodable: ["page" : page])
            

        case .tvShows(let timeWindow, let page):
            return Endpoint(path: "3/trending/tv".appending("/\(timeWindow.rawValue)"),
                               method: .get,
                               queryParametersEncodable: ["page" : page])
            
        case .people(let timeWindow, let page):
            return Endpoint(path: "3/trending/person".appending("/\(timeWindow.rawValue)"),
                               method: .get,
                               queryParametersEncodable: ["page" : page])
        }
    }
    
}

extension APIEndpoints.Movies {
    func endpoint() -> Endpoint<T>{
        switch self {
        case .detail(let id):
            return Endpoint(path: "3/movie/\(id)",
                            method: .get)
        case .videos(id: let id):
            return Endpoint(path: "3/movie/\(id)/videos",
                            method: .get)
        case .credits(id: let id):
            return Endpoint(path: "3/movie/\(id)/credits",
                            method: .get)
        }
    }
}

extension APIEndpoints.Media {
    func endpoint() -> Endpoint<T> {
        switch self {
        case .search(query: let query):
            return Endpoint(path: "3/search/multi",
                            method: .get,
                            queryParametersEncodable: query)
        }
    }
}

extension APIEndpoints.TvShow {
    func endpoint() -> Endpoint<T>{
        switch self {
        case .detail(let id):
            return Endpoint(path: "3/tv/\(id)",
                            method: .get)
        case .videos(id: let id):
            return Endpoint(path: "3/tv/\(id)/videos",
                            method: .get)
        }
    }
}

extension APIEndpoints.Auth {
    func endpoint() -> Endpoint<T>{
        switch self {
        case .requestToken:
            return Endpoint(path: "3/authentication/token/new",
                            method: .get)
        case .login(request: let request):
            return Endpoint(path: "3/authentication/token/validate_with_login",
                            method: .post, headerParameters: ["Content-Type" : "application/json"], bodyParametersEncodable: request)
        }
    }
}
