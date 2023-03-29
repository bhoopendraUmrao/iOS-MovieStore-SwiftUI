//
//  Video.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/3/23.
//

import Foundation

struct Video: Equatable, Identifiable {
    let name: String
    let key: String
    let site: VideoSource
    let size: Int
    let type: VideoType
    let official: Bool
    let published_at: String
    let id: String
}

extension Video {
    enum VideoType: String {
        case Trailer
        case BehindTheScenes = "Behind the Scenes"
        case Featurette
        case Teaser
        case Clip
        case Unknom
    }
    
    enum VideoSource: String {
        case YouTube
        case Vimeo
        
        func thumbnail(videoId: String) -> URL? {
            switch self {
            case .YouTube:
                return URL(string: String(format: "https://img.youtube.com/vi/%@/0.jpg", videoId))
            case .Vimeo:
                return URL(string: String(format: "https://vumbnail.com/%@_large.jpg", videoId))
            }
            
        }
        
        func video(videoId: String) -> URL? {
            switch self {
            case .YouTube:
                return URL(string: String(format: "https://www.youtube.com/embed/%@?&autoplay=1", videoId))
            case .Vimeo:
                return URL(string: String(format: "https://vimeo.com/%@", videoId))
            }
            
        }
    }
}
