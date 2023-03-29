//
//  MediaListView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/24/23.
//

import SwiftUI

struct MediaListView: View {
    var mediaList: [MediaListItemViewModel]
    var loadNext: () -> ()
    var twoColumnGrid = [GridItem(.fixed(UIScreen.main.bounds.width/2), spacing: 0),
                         GridItem(.fixed(UIScreen.main.bounds.width/2), spacing: 0)]
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    var body: some View {
        ScrollView {
            LazyVGrid(columns: twoColumnGrid,spacing: 0) {
                ForEach(mediaList, id: \.self) { media in
                    NavigationLink() {
                        switch media.mediaType {
                        case .tv:
                            appConfigurator.makeTvShowDetailScene(mediaID: media.id)
                            .navigationBarTitleDisplayMode(.inline)
                        case .movie, .person, .none:
                            appConfigurator.makeMovieDetailScene(mediaID: media.id)
                            .navigationBarTitleDisplayMode(.inline)
                        }
                        
                    } label: {
                        MovieListItemView(movie: .init(id: media.id,
                                                       title: media.title,
                                                       releaseDate: media.releasedDate,
                                                       overview: media.overview,
                                                       posterImage: media.posterImage,
                                                       rating: media.rating))
                        .padding(8)
                    }
                    .onAppear {
                        if media == mediaList.last {
                            loadNext()
                        }
                    }
                }
            }
        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListView(mediaList: [MediaListItemViewModel(id: 1,
                                                         title: "Test",
                                                         releasedDate: "11/02/2022",
                                                         mediaType: .movie,
                                                         language: "en_US",
                                                         rating: 5.5,
                                                         overview: "Test name", posterImage: URL(string: "https://api.lorem.space/image/movie?w=150&h=220"))], loadNext: {})
    }
}
