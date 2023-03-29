//
//  MovieDetailResponse+Mapping.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/2/23.
//

import Foundation

struct MovieDetailResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "title"
        case releaseDate = "release_date"
        case overview
        case genres
        case rating = "vote_average"
        case language = "original_language"
        case posterPath = "poster_path"
        case budget = "budget"
        case revenue = "revenue"
        case isAdult = "adult"
        case runtime = "runtime"
        case tagline = "tagline"
    }
    let id: Int
    let title: String?
    let releaseDate: String?
    let overview: String?
    let genres: [Genre]?
    let rating: Float?
    let language: String?
    let posterPath: String?
    let budget: Double?
    let revenue: Double?
    let isAdult: Bool
    let runtime: Int?
    let tagline: String?
}

extension MovieDetailResponse {
    struct Genre: Decodable {
        var id: Int
        var name: String
    }
}

extension MovieDetailResponse {
    func toDomain() -> MovieDetail {
        return .init(id: id,
                     title: title,
                     releaseDate: dateFormatter.date(from: releaseDate ?? ""),
                     overview: overview,
                     genres: genres?.compactMap { MovieDetail.Genre(id: $0.id, name: $0.name)},
                     rating: rating,
                     language: language,
                     posterPath: posterPath,
                     budget: budget,
                     revenue: revenue,
                     isAdult: isAdult,
                     runtime: runtime,
                     tagline: tagline)
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
