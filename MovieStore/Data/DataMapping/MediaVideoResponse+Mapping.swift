//
//  MediaVideoResponse+Mapping.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/3/23.
//

import Foundation

struct MediaVideoResponse: Decodable {
    let id: Int
    let results: [MediaVideo]
}

extension MediaVideoResponse {
    struct MediaVideo: Decodable {
        let name: String
        let key: String
        let site: VideoSource
        let size: Int
        let type: VideoType
        let official: Bool
        let published_at: String
        let id: String
    }
}

extension MediaVideoResponse {
    enum VideoType: String, Decodable {
        case Trailer
        case BehindTheScenes = "Behind the Scenes"
        case Featurette
        case Teaser
        case Clip
        case Bloopers
    }
    
    enum VideoSource: String, Decodable {
        case YouTube
        case Vimeo
    }
}

extension MediaVideoResponse {
    func toDomain() -> [Video] {
        return results.compactMap { $0.toDomain() }
    }
}

extension MediaVideoResponse.MediaVideo {
    func toDomain() -> Video {
        return .init(name: name,
                     key: key,
                     site: site.toDomain(),
                     size: size,
                     type: type.toDomain(),
                     official: official,
                     published_at: published_at,
                     id: id)
    }
}

extension MediaVideoResponse.VideoSource {
    func toDomain() -> Video.VideoSource {
        switch self {
        case .YouTube:
            return .YouTube
        case .Vimeo:
            return .Vimeo
        }
    }
}

extension MediaVideoResponse.VideoType {
    func toDomain() -> Video.VideoType {
        switch self {
        case .Trailer:
            return .Trailer
        case .BehindTheScenes:
            return .BehindTheScenes
        case .Featurette:
            return .Featurette
        case .Teaser:
            return .Teaser
        case .Clip:
            return .Clip
        default:
            return .Unknom
        }
    }
}
