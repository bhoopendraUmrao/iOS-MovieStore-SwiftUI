//
//  MovieListitemViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/22/23.
//

import Foundation

protocol MediaListItem {
    var id: Int { get }
    var title: String { get }
    var releaseDate: String { get }
    var overview: String { get }
    var posterImage: URL { get }
}

struct MovieListitemViewModel:  Identifiable, Equatable, Hashable {
    init(id: Int, title: String, releaseDate: String, overview: String, posterImage: URL?, rating: Float?) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.overview = overview
        self.posterImage = posterImage
        self.rating = rating
    }
    
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let posterImage: URL?
    let rating: Float?
}

extension MovieListitemViewModel {
    init(movie: Media) {
        id = movie.id
        title = movie.title ?? ""
        overview = movie.overview ?? ""
        if let releaseDate = movie.releaseDate {
            self.releaseDate = "\(NSLocalizedString("Release Date", comment: "")): \(dateFormatter.string(from: releaseDate))"
        } else {
            self.releaseDate = NSLocalizedString("To be announced", comment: "")
        }
        if let posterPath = movie.posterPath,
           let url = URL(string: String(format: "https://image.tmdb.org/t/p/w185%@",
                                                                           posterPath))  {
            posterImage = url
        } else {
            posterImage = nil
        }
        rating = movie.rating
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
