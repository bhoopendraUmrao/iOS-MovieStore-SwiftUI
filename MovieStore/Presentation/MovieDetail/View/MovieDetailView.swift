//
//  MovieDetailView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import SwiftUI

struct MovieDetailView<MovieDetailVM>: View where MovieDetailVM: MovieDetailViewModel {
    @ObservedObject var viewModel: MovieDetailVM
    @State private var showingLogin = false
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    @Environment(\.managedObjectContext) var viewContext
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack(alignment: .top) {
                    postImage
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.movieDetail?.title ?? "NA")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.headline)
                        Text(viewModel.movieDetail?.releasedDate ?? "NA")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor.lightGray))
                            .fontWeight(.semibold)
                        HStack(alignment: .top) {
                            UserRatingView(rating: viewModel.movieDetail?.rating ?? 0.0)
                                .frame(width: 60, height: 60, alignment: .top)
                            Text("User Score")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, maxHeight: 70, alignment: .topLeading)
                                .padding(.top, 4)
                        }
                        .padding(.vertical, 4)
                        
                        VStack(alignment: .leading) {
                            Text("Budget:")
                                .font(.title3)
                                .fontWeight(.semibold)
                            let budget = String(format: "$%.1f", viewModel.movieDetail?.budget ?? 0.0)
                            Text(budget)
                        }
                        .padding(.bottom, 8)
                        
                        VStack(alignment: .leading) {
                            Text("Revenue:")
                                .font(.title3)
                                .fontWeight(.semibold)
                            let revenue = String(format: "$%.1f", viewModel.movieDetail?.revenue ?? 0.0)
                            Text(revenue)
                        }
                        .padding(.bottom, 8)
                    }
                    .padding(.trailing, 16)
                }
                tagline
                HStack {
                    addToFavoriteButton
                        .padding(.horizontal, 8)
                    Spacer()
                }
                Group {
                    Text("Overview")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(viewModel.movieDetail?.overview ?? "NA")
                        .lineSpacing(1.5)
                        .font(.body)
                    HStack {
                        Text("Geners: ")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(viewModel.movieDetail?.geners.compactMap{$0.name}.joined(separator: ", ") ?? "NA")
                    }
                    Text("Casts:")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(0)
                    CharacterListView(casts: viewModel.castList)
                    Text("Videos:")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(0)
                    HVideoListView(videoList: viewModel.videoList)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .padding(.top, 4)
                Spacer()
            }
            .onAppear {
                viewModel.didFetch()
            }
        }
    }
    
    private var addToFavoriteButton: some View {
        Button(action: {
            if appConfigurator.isUserLoggedIn {
                let favoriteMovie = Favorite(context: viewContext)
                favoriteMovie.title = viewModel.movieDetail?.title
                favoriteMovie.releaseDate = viewModel.movieDetail?.releasedDate
                favoriteMovie.id = Int32(viewModel.movieDetail?.id ?? 0)
                try? viewContext.save()
            } else {
                showingLogin.toggle()
            }
        }, label: {
            HStack {
                Group {
                    Text("Mark as favorite")
                    Image(systemName: "star")
                        .padding(.trailing, 8)
                }
                .padding(.leading, 8)
                .padding(.vertical, 8)
            }
            .border(.red, width: 1)
            .foregroundColor(.red)
            
        })
        .sheet(isPresented: $showingLogin) {
            appConfigurator.makeLoginView()
        }
    }
    
    private var postImage: some View {
        ZStack {

            AsyncImage(url: viewModel.movieDetail?.posterImage) { image in
                image.resizable()
                    .clipped()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 280)
            } placeholder: {
                ZStack {
                    Color.clear
                        .frame(minWidth: 250, maxWidth: .infinity,minHeight: 280, maxHeight: 280)
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                        .font(.body)
                        .progressViewStyle(.automatic)
                }
            }
        }
    }
    
    private var tagline: some View {
        Text(viewModel.movieDetail?.tagline ?? "NA")
            .italic()
            .font(.callout)
            .foregroundColor(Color(UIColor.lightGray))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigurationContainer().makeMovieDetailScene(mediaID: 804150)
    }
}
