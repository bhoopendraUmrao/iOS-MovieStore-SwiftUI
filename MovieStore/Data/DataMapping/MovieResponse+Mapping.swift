//
//  MovieResponse+Mapping.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/28/23.
//

import Foundation

struct MovieResponse: MediaResponse, Decodable {
    
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

extension MovieResponse {
    struct Media: MediaProtocol {
        private enum CodingKeys: String, CodingKey {
            case id
            case title = "title"
            case genre
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
            case language = "original_language"
            case rating = "vote_average"
            case mediaType = "media_type"
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
    }
}
