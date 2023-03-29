//
//  MediaListItemViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

struct MediaListItemViewModel: Hashable, Equatable, Identifiable {
    enum MediaType: String {
        case movie, tv, person
        
        var value: String {
            self.rawValue
        }
    }
    let id: Int
    let title: String
    let releasedDate: String
    let mediaType: MediaType?
    let language: String?
    let rating: Float?
    let overview: String
    let posterImage: URL?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}

extension MediaListItemViewModel {
    init(movie: Media) {
        id = movie.id
        title = movie.title ?? ""
        overview = movie.overview ?? ""
        if let releaseDate = movie.releaseDate {
            self.releasedDate = "\(dateFormatter.string(from: releaseDate))"
        } else {
            self.releasedDate = NSLocalizedString("To be announced", comment: "")
        }
        mediaType = MediaType(rawValue: movie.mediaType?.value ?? "")
        language = movie.language
        rating = movie.rating
        if let posterPath = movie.posterPath,
           let url = URL(string: String(format: "https://image.tmdb.org/t/p/w185%@",posterPath))  {
            posterImage = url
        } else {
            posterImage = nil
        }
    }
    
}

