//
//  TvShowDetailResponse+Mapping.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/16/23.
//

import Foundation

struct TvShowDetailResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case firstAirDatae = "first_air_date"
        case overview
        case genres
        case rating = "vote_average"
        case language = "original_language"
        case posterPath = "poster_path"
        case budget = "budget"
        case isAdult = "adult"
        case tagline = "tagline"
        case totalSeasons = "number_of_seasons"
        case lastAirDate = "last_air_date"
        case nextEpisodeAirDate =  "next_episode_to_air.air_date"
        case networks = "networks"
        case seasons = "seasons"
        case audioLanguage = "spoken_languages"
    }
    let id: Int
    let title: String?
    let firstAirDatae: String?
    let overview: String?
    let genres: [Genre]?
    let rating: Float?
    let language: String?
    let posterPath: String?
    let budget: Double?
    let isAdult: Bool
    let tagline: String?
    let totalSeasons: Int?
    let lastAirDate: String?
    let nextEpisodeAirDate: String?
    let networks: [Network]?
    let seasons: [Season]?
    let audioLanguage: [Audio]?
}

extension TvShowDetailResponse {
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
}

extension TvShowDetailResponse {
    struct Network: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case name = "name"
            case logo = "logo_path"
            case originConuntry = "origin_country"
        }
        let id: Int
        let name: String
        let logo: String
        let originConuntry: String
    }
}

extension TvShowDetailResponse {
    struct Season: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case name = "name"
            case overview = "overview"
            case posterPath = "poster_path"
            case seasonNumber = "season_number"
            case episodeCount = "episode_count"
            case airDate = "air_date"
        }
        let id: Int
        let name: String
        let overview: String
        let posterPath: String
        let seasonNumber: Int
        let episodeCount: Int
        let airDate: String?
    }
}

extension TvShowDetailResponse {
    struct Audio: Decodable {
        private enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case name = "name"
        }
        let name: String
        let englishName: String
    }
}

extension TvShowDetailResponse {
    func toDomain() -> TvShowDetail {
        return .init(id: id,
                     title: title,
                     firstAirDatae: dateFormatter.date(from: firstAirDatae ?? ""),
                     overview: overview,
                     genres: genres?.compactMap { TvShowDetail.Genre(id: $0.id, name: $0.name)},
                     rating: rating,
                     language: language,
                     posterPath: posterPath,
                     budget: budget,
                     isAdult: isAdult,
                     tagline: tagline,
                     totalSeasons: totalSeasons,
                     lastAirDate: dateFormatter.date(from: lastAirDate ?? ""),
                     nextEpisodeAirDate: dateFormatter.date(from: nextEpisodeAirDate ?? ""),
                     network: networks?.compactMap{ .init(id: $0.id,
                                                          name: $0.name,
                                                          logo: $0.logo,
                                                          originConuntry: $0.originConuntry)},
                     audioLanguage: audioLanguage?.compactMap{.init(name: $0.name, englishName: $0.englishName)})
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
