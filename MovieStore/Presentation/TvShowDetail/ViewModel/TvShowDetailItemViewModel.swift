//
//  TvShowDetailItemViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/16/23.
//

import Foundation

struct TvShowDetailItemViewModel {

    let id: Int

    let title: String
    
    let overview: String
    
    let releasedDate: String
    
    let posterImage: URL?
    
    let posterImageIsHidden: Bool
            
    let rating: Float
    
    let tagline: String
    
    let geners: [Genere]
    
    let lastAirDate: String
        
    let language: String?
    
    let isAdult: Bool
    
    let totalSeasons: Int?
    
    let nextEpisodeAirDate: String?
    
    let network: String?
    
    let audioLanguage: String?
    
    init(id: Int,
         title: String,
         overview: String,
         releasedDate: String,
         posterImage: URL?,
         posterImageIsHidden: Bool,
         rating: Float,
         tagline: String,
         geners: [TvShowDetailItemViewModel.Genere],
         lastAirDate: String,
         language: String?,
         isAdult: Bool,
         totalSeasons: Int?,
         nextEpisodeAirDate: String?,
         network: String,
         audioLanguage: [String]) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releasedDate = releasedDate
        self.posterImage = posterImage
        self.posterImageIsHidden = posterImageIsHidden
        self.rating = rating
        self.tagline = tagline
        self.geners = geners
        self.lastAirDate = lastAirDate
        self.language = language
        self.isAdult = isAdult
        self.totalSeasons = totalSeasons
        self.nextEpisodeAirDate = nextEpisodeAirDate
        self.network = network
        self.audioLanguage = audioLanguage.joined(separator: ", ")
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension TvShowDetailItemViewModel {
    init(tvShowDetail: TvShowDetail) {
        id = tvShowDetail.id
        title = tvShowDetail.title ?? "NA"
        overview = tvShowDetail.overview ?? "NA"
        if let releaseDate = tvShowDetail.firstAirDatae {
            self.releasedDate = "\(dateFormatter.string(from: releaseDate))"
        } else {
            self.releasedDate = NSLocalizedString("To be announced", comment: "")
        }
        posterImage = URL(string: String(format: "https://image.tmdb.org/t/p/w185%@",
                                         tvShowDetail.posterPath ?? "")) 
        posterImageIsHidden = posterImage != nil ? false : true
        rating = tvShowDetail.rating ?? 0.0
        tagline = tvShowDetail.tagline ?? "NA"
        geners = tvShowDetail.genres?.compactMap{ TvShowDetailItemViewModel.Genere(id: $0.id, name: $0.name)} ?? []
        
        if let lastAirDate = tvShowDetail.lastAirDate {
            self.lastAirDate = "\(dateFormatter.string(from: lastAirDate))"
        } else {
            self.lastAirDate = NSLocalizedString("To be announced", comment: "")
        }
        
        language = tvShowDetail.language
        isAdult = tvShowDetail.isAdult
        totalSeasons = tvShowDetail.totalSeasons
        if let nextEpisodeAirDate = tvShowDetail.nextEpisodeAirDate {
            self.nextEpisodeAirDate = "\(dateFormatter.string(from: nextEpisodeAirDate))"
        } else {
            self.nextEpisodeAirDate = NSLocalizedString("To be announced", comment: "")
        }
        self.network = tvShowDetail.network?.first?.name
        self.audioLanguage = tvShowDetail.audioLanguage?.compactMap{$0.name}.joined(separator: ", ")
    }
}

extension TvShowDetailItemViewModel {
    struct Genere: Identifiable {
        let id: Int
        let name: String
    }
}
