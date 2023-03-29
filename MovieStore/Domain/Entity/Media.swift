//
//  Media.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

protocol MediaTrending {
    var value: String { get }
}

enum MediaTrendingType: String, MediaTrending, CaseIterable {
    case movie, tv
    var value: String {
        self.rawValue
    }
}

enum MediaTrendingTime: String, MediaTrending, CaseIterable {
    case day, week
    var value: String {
        self.rawValue
    }
}

extension URL {

    func appendingPathComponent(_ filterType: MediaTrendingTime) -> Self {
        appendingPathComponent(filterType.rawValue)
    }

}

struct Media: Equatable, Identifiable {
    typealias Indentifier = Int
    enum Genre {
        case adventure
        case scienceFiction
    }
    enum MediaType: String {
        case movie, tv, person
        
        var value: String {
            self.rawValue
        }
    }
    let id: Indentifier
    let title: String?
    let directedBy: String? = nil
    let releaseDate: Date?
    let overview: String?
    let mediaType: MediaType?
    let genre: Genre?
    let rating: Float?
    let language: String?
    let posterPath: String?
}

struct MediaPage {
    let page: Int
    let totalPage: Int
    let medias: [Media]
}

struct MediaQuery: Equatable {
    let query: String
}



