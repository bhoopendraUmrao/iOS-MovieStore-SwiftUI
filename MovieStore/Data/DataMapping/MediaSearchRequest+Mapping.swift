//
//  MediaSearchRequest+Mapping.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/22/23.
//

import Foundation

struct MediaSearchRequest: Encodable {
    let query: String
    let page: Int
}
