//
//  TvShowDetail.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/16/23.
//

import Foundation

struct TvShowDetail: Equatable, Identifiable {
    let id: Int
    let title: String?
    let firstAirDatae: Date?
    let overview: String?
    let genres: [Genre]?
    let rating: Float?
    let language: String?
    let posterPath: String?
    let budget: Double?
    let isAdult: Bool
    let tagline: String?
    let totalSeasons: Int?
    let lastAirDate: Date?
    let nextEpisodeAirDate: Date?
    let network: [Network]?
    let audioLanguage: [Audio]?
}

extension TvShowDetail {
    struct Genre: Equatable, Identifiable {
        var id: Int
        var name: String
    }
}

extension TvShowDetail {
    struct Network: Equatable, Identifiable {
        var id: Int
        var name: String
        var logo: String
        var originConuntry: String
    }
}

extension TvShowDetail {
    struct Audio: Equatable {
        let name: String
        let englishName: String
    }
}
