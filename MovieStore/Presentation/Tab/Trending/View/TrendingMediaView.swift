//
//  TrendingMediaView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import SwiftUI

struct TrendingMediaView<ViewModel>: View where ViewModel: TrendingMediaViewModel {
    @ObservedObject var viewModel: ViewModel
    @State var selectedFilter: String = "all"
    @State var showFilter: Bool = false
    @State var sideMenuImageName: String = "text.justify"
    @State var searchText: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                MediaListView(mediaList: viewModel.mediaList, loadNext: loadNext)
                    .padding(.horizontal, 8)
                    .disabled(showFilter)
                    .opacity(showFilter ? 0.5 :  1.0)
                    .animation(.easeInOut(duration: 0.4), value: showFilter)
                    .navigationTitle("Trending")
                
                GeometryReader { _ in
                    let bounds = UIScreen.main.bounds
                    HStack {
                        Spacer()
                        TrendingMediaFilterView(mediaFilters: $viewModel.mediaFilters)
                            .frame(width: bounds.width * 0.65)
                            .offset(x: showFilter ? 0 : bounds.width, y: 0)
                            .animation(.easeInOut(duration: 0.4), value: showFilter)
                    }
                }
                .toolbar {
                    /*
                    ToolbarItem(placement: .navigationBarTrailing) {
                        sideMenuButton
                    }
                     */
                }
            }
            .onAppear {
                guard viewModel.mediaList.count == 0 else { return }
                viewModel.didFetch(for: .movie, time: .day)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search for movies, tv shows...")
        .onSubmit(of: .search, {
            viewModel.search(text: searchText)
        })
    }
    
    var sideMenuButton: some View {
        Button {
            showFilter.toggle()
            sideMenuImageName = showFilter ? "selection.pin.in.out" :  "text.justify"
            if !showFilter {
                viewModel.reset()
                filter(reset: !showFilter)
            }
        } label: {
            Image(systemName: sideMenuImageName)
        }
    }
    
    private func loadNext() {
        self.viewModel.reset()
    }
    
    private func filter(reset: Bool) {
        if reset {
            var selectedMediaType: MediaTrendingType = .movie
            var selectedMediaTime: MediaTrendingTime = .day
            if let mediaType = viewModel.mediaFilters.first?.selectedFilter, let media = MediaTrendingType(rawValue: mediaType) {
                selectedMediaType = media
            }
            if let mediatime = viewModel.mediaFilters.first?.selectedFilter, let time = MediaTrendingTime(rawValue: mediatime) {
                selectedMediaTime = time
            }
            viewModel.didFetch(for: selectedMediaType, time: selectedMediaTime)
        }
    }
}

struct TrendingMediaView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigurationContainer().makeTrendingScene()
    }
}
