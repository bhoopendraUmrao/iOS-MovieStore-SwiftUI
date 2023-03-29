//
//  TrendingMediaFilterViewModel.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import Foundation

struct TrendingMediaFilterViewModel  {
    let title: String
    let filters: [String]
    var selectedFilter: String {
        didSet {
            print("DEBUG: Value updated on TrendingMediaFilterViewModel")
        }
    }
    init(title: String, filters: [String]) {
        self.title = title
        self.filters = filters
        self.selectedFilter = filters.first ?? ""
    }
}
