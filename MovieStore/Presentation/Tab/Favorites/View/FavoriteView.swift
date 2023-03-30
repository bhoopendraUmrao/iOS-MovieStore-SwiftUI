//
//  FavoriteView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/28/23.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var viewContext
    @State private var showLogin: Bool = false
    @FetchRequest(
        entity: Favorite.entity(),
        sortDescriptors: []
    ) private var favorites: FetchedResults<Favorite>
    @Namespace var namespace
    
    var twoColumnGrid = [GridItem(.fixed(UIScreen.main.bounds.width/2), spacing: 0),
                         GridItem(.fixed(UIScreen.main.bounds.width/2), spacing: 0)]
    
    var body: some View {
        if appConfigurator.isUserLoggedIn {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: twoColumnGrid,spacing: 0) {
                        ForEach(favorites, id: \.id) { item in
                            NavigationLink {
                                appConfigurator.makeMovieDetailScene(mediaID: Int(item.id))
                            } label: {
                                MovieListItemView(movie: .init(id: Int(item.id),
                                                               title: item.title ?? "NA",
                                                               releaseDate: item.releaseDate ?? "NA",
                                                               overview: "",
                                                               posterImage: item.posterPath,
                                                               rating: item.rating), namespace: namespace)
                                .padding(8)
                                .frame(height: 300)
                            }
                        }
                    }
                }
                .navigationTitle("Favorite")
            }
        } else {
            Button {
                showLogin.toggle()
            } label: {
                Text("Log In")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(height: 50)
                    .padding(.horizontal, 110)
                    .background(colorScheme == .dark ? .white : .black)
                    .cornerRadius(5)
            }
            .sheet(isPresented: $showLogin) {
                appConfigurator.makeLoginView()
            }
        }
    }
}

