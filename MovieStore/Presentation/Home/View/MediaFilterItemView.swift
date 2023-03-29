//
//  MediaFilterItemView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/24/23.
//

import SwiftUI

struct MediaFilterItemView: View {
    @Binding var mediaFilter: TrendingMediaFilterViewModel
    @State var selectedValue: String
    var body: some View {
        let binding = Binding<String>(
            get: { self.selectedValue },
            set: {
                self.selectedValue = $0
                self.mediaFilter.selectedFilter = self.selectedValue
            })
        Picker(selection: binding) {
            
            ForEach(mediaFilter.filters, id: \.self) { item in
                Text(item.capitalized)
            }
        } label: {
            Text(mediaFilter.title)
                .font(.headline)
        }
        .pickerStyle(InlinePickerStyle())
    }
}

struct MediaFilterItemView_Previews: PreviewProvider {
    static var previews: some View {
        MediaFilterItemView(mediaFilter: .constant(.init(title: "Media Type", filters: MediaTrendingType.allCases.compactMap{$0.value})), selectedValue: MediaTrendingType.movie.value)
    }
}
