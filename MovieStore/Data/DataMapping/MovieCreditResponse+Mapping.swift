//
//  MovieCreditResponse+Mapping.swift
//  MovieStore
//
//  Created by Himanshu Jindal on 24/03/23.
//

import Foundation

struct MovieCreditResponse: Decodable {
    let id: Int
    let cast: [Cast]
}

extension MovieCreditResponse {
    struct Cast: Decodable {
        enum Gender: Int, Decodable {
            case male = 2
            case female =  1
            case unknown = 0
        }
        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case originalName = "original_name"
            case id = "id"
            case posterPath = "profile_path"
            case characterName = "character"
            case creditId = "credit_id"
            case gender = "gender"
            case department = "known_for_department"
        }
        let name: String
        let originalName: String
        let id: Int
        let posterPath: String?
        let characterName: String
        let creditId: String
        let gender: Gender?
        let department: String
    }
}

extension MovieCreditResponse {
    func toDomain() -> [CharacterCast] {
        return cast.compactMap{
            if $0.posterPath != nil {
                return CharacterCast.init(id: $0.id,
                                   name: $0.name,
                                   characterName: $0.characterName,
                                   image: URL(string: String(format: "https://image.tmdb.org/t/p/w185%@",$0.posterPath ?? "" )))
            }
            return nil
        }
    }
}
