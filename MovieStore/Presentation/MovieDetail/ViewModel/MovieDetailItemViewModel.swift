//
//  MovieDetailItemViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/2/23.
//

import Foundation

struct MovieDetailItemViewModel {
    
    let id: Int
    
    let title: String
    
    let overview: String
    
    let releasedDate: String
    
    let posterImage: URL?
    
    let posterImageIsHidden: Bool
    
    let budget: Double
    
    let revenue: Double
    
    let rating: Float
    
    let tagline: String
    
    let geners: [Genere]
    
    init(id: Int,
         title: String,
         overview: String,
         releasedDate: String,
         posterImage: URL?,
         budget: Float = 0.0,
         revenue: Float = 0.0,
         rating: Float,
         tagline: String,
         geners: [Genere]) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releasedDate = releasedDate
        self.posterImage = URL(string: "https://api.lorem.space/image/movie?w=250&h=280")//posterImage
        self.posterImageIsHidden = posterImage != nil ? false : true
        self.budget = Double(budget)
        self.revenue = Double(revenue)
        self.rating = rating
        self.tagline = tagline
        self.geners = geners
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension MovieDetailItemViewModel {
    init(movieDetail: MovieDetail) {
        id = movieDetail.id
        title = movieDetail.title ?? "NA"
        overview = movieDetail.overview ?? "NA"
        if let releaseDate = movieDetail.releaseDate {
            self.releasedDate = "\(dateFormatter.string(from: releaseDate))"
        } else {
            self.releasedDate = NSLocalizedString("To be announced", comment: "")
        }
        posterImage = URL(string: String(format: "https://image.tmdb.org/t/p/w185%@",
                                         movieDetail.posterPath ?? "")) //URL(string: "https://api.lorem.space/image/movie?w=250&h=280")
        posterImageIsHidden = posterImage != nil ? false : true
        budget = movieDetail.budget ?? 0.0
        revenue = movieDetail.revenue ?? 0.0
        rating = movieDetail.rating ?? 0.0
        tagline = movieDetail.tagline ?? "NA"
        geners = movieDetail.genres?.compactMap{ MovieDetailItemViewModel.Genere(id: $0.id, name: $0.name)} ?? []
    }
}

extension MovieDetailItemViewModel {
    struct Genere: Identifiable {
        let id: Int
        let name: String
    }
}
