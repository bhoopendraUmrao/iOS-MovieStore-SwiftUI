//
//  TrendingMediaFilterView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/24/23.
//

import SwiftUI

struct TrendingMediaFilterView: View {
    @Binding var mediaFilters: [TrendingMediaFilterViewModel]
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach($mediaFilters, id: \.title) { filter in
                    MediaFilterItemView(mediaFilter: filter, selectedValue: filter.selectedFilter.wrappedValue)
                        .padding(.horizontal, 8)
                }
            }            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TrendingMediaFilterView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingMediaFilterView(mediaFilters:
                .constant([TrendingMediaFilterViewModel(title: "Media Type", filters: MediaTrendingType.allCases.compactMap{$0.value}),
                           TrendingMediaFilterViewModel(title: "Time", filters: MediaTrendingTime.allCases.compactMap{$0.value})]))
    }
}
