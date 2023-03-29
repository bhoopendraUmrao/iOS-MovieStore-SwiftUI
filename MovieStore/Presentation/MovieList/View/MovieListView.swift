//
//  MovieListView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/22/23.
//

import SwiftUI

struct MovieListView<Model>: View where Model: MovieListViewModel {
    @ObservedObject var viewModel: Model
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    @Namespace var namespace
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.movies, id: \.self) { movie in
                        NavigationLink() {
                            appConfigurator.makeMovieDetailScene(mediaID: movie.id)
                        } label: {
                            MovieListItemView(movie: movie, namespace: namespace)
                        }
                        .onAppear {
                            if viewModel.movies.last == movie {
                                viewModel.didLoadNextPage()
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .onAppear {
                viewModel.didSearch(query: "Wednesday")
            }
            .navigationTitle(Text("Movie News"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Text("Search")
                    }
                }
            }
        }
    }
}


struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigurationContainer().makeMoviesSceneDIContainer()
    }
}

