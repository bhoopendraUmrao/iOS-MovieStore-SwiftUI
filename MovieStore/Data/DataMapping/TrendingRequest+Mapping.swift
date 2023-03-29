//
//  TrendingRequest+Mapping.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

struct TrendingRequest: Encodable {
    let mediaType: String
    let timeWindow: String
}
