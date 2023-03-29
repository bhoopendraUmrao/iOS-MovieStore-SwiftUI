//
//  MediaResponse.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/22/23.
//

import Foundation


// MARK: - Data Transfer Object

protocol MediaResponse: Decodable {
    var page: Int { get }
    var totalPages: Int { get }
    var medias: [MediaProtocol] { get }
}

protocol MediaProtocol: Decodable {
    var id: Int { get }
    var title: String? { get }
    var genre: Genre? { get }
    var posterPath: String? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
    var language: String? { get }
    var rating: Float? { get }
    var mediaType: MediaType? { get }
}

enum Genre: String, Decodable {
    case adventure
    case scienceFiction = "science_fiction"
}

enum MediaType: String, Decodable {
    case movie, tv, person
    
    var value: String {
        self.rawValue
    }
}

// MARK: - Mappings to Domain

extension MediaResponse {
    func toDomain() -> MediaPage {
        return .init(page: page,
                     totalPage: totalPages,
                     medias: medias.map { $0.toDomain() })
    }
}

extension MediaProtocol {
    func toDomain() -> Media {
        return .init(id: Media.Indentifier(id),
                     title: title,
                     releaseDate: dateFormatter.date(from: releaseDate ?? ""),
                     overview: overview,
                     mediaType: mediaType?.toDomain(),
                     genre: genre?.toDomain(),
                     rating: rating,
                     language: language,
                     posterPath: posterPath)
        
    }
}

extension Genre {
    func toDomain() -> Media.Genre {
        switch self {
        case .adventure: return .adventure
        case .scienceFiction: return .scienceFiction
        }
    }
}

extension MediaType {
    func toDomain() -> Media.MediaType {
        switch self {
        case .person:
            return .person
        case .movie:
            return .movie
        case .tv:
            return .tv
        }
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


struct DefaultMediaResponse: MediaResponse, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case medias = "results"
    }
    let page: Int
    let totalPages: Int
    let medias: [MediaProtocol]
    
    init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try decoder.decode(Int.self, forKey: .page)
        self.totalPages = try decoder.decode(Int.self, forKey: .totalPages)
        self.medias = try decoder.decode([Media].self, forKey: .medias)
    }
}

extension DefaultMediaResponse {
    struct Media: MediaProtocol {
        private enum MediaTypeCodinfKey: String, CodingKey {
            case mediaType = "media_type"
            case title = "title"
            case name = "name"
        }
        private enum CodingKeys: String, CodingKey {
            case id
            case genre
            case posterPath = "poster_path"
            case overview
            case releaseDate = "first_air_date"
            case language = "original_language"
            case rating = "vote_average"
        }
        
        let id: Int
        let title: String?
        let genre: Genre?
        let posterPath: String?
        let overview: String?
        let releaseDate: String?
        let language: String?
        let rating: Float?
        let mediaType: MediaType?
        
        init(from decoder: Decoder) throws {
            let mediaTypeDecoder = try decoder.container(keyedBy: MediaTypeCodinfKey.self)
            mediaType = try mediaTypeDecoder.decode(MediaType.self, forKey: .mediaType)
            switch mediaType ?? .none {
            case .tv:
                title = try mediaTypeDecoder.decodeIfPresent(String.self, forKey: .name)
            case .movie:
                title = try mediaTypeDecoder.decodeIfPresent(String.self, forKey: .title)
            case .person:
                title = try mediaTypeDecoder.decodeIfPresent(String.self, forKey: .name)
            case .none:
                title = try mediaTypeDecoder.decodeIfPresent(String.self, forKey: .title)
            }
            let decoder = try decoder.container(keyedBy: CodingKeys.self)
            id = try decoder.decodeIfPresent(Int.self, forKey: .id) ?? 0
            genre = try decoder.decodeIfPresent(Genre.self, forKey: .genre)
            posterPath = try decoder.decodeIfPresent(String.self, forKey: .posterPath)
            overview = try decoder.decodeIfPresent(String.self, forKey: .overview)
            releaseDate = try decoder.decodeIfPresent(String.self, forKey: .releaseDate)
            language = try decoder.decodeIfPresent(String.self, forKey: .language)
            rating = try decoder.decodeIfPresent(Float.self, forKey: .rating)
        }
    }
}
