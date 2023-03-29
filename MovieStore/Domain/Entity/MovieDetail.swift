//
//  MovieDetail.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/2/23.
//

import Foundation

struct MovieDetail: Equatable, Identifiable {
    typealias Indentifier = Int
    let id: Indentifier
    let title: String?
    let releaseDate: Date?
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

extension MovieDetail {
    struct Genre: Equatable, Identifiable {
        var id: Int
        var name: String
    }
}
