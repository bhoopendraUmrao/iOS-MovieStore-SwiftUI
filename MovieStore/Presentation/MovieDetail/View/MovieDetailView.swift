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
    @FetchRequest var favorite: FetchedResults<Favorite>
    @State var show: Bool = false
    @State var isFavorite: Bool = false
    init(movieId: Int32, viewModel: MovieDetailVM) {
        _favorite = FetchRequest<Favorite>(entity: Favorite.entity(),
                                           sortDescriptors: [],
                                           predicate: NSPredicate(format: "id == %@",argumentArray: [movieId]))
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            movieBanner
                .frame(height: UIScreen.main.bounds.height*0.30)
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 8) {
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
                        CharacterListView(casts: viewModel.castList)
                        Text("Videos:")
                            .font(.title3)
                            .fontWeight(.bold)
                        HVideoListView(videoList: viewModel.videoList)
                    }
                    .padding(.horizontal, 8)
                }
            }
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            if viewModel.movieDetail == nil {
                viewModel.didFetch()
            }
            isFavorite = favorite.count == 0 ? false : true
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CircleBackButton(),
                            trailing: FavoriteButton(isSelected: $isFavorite).onChange(of: isFavorite, perform: { newValue in
            toggleFavorite(newValue)
        }))
    }
    
    private var movieBanner: some View {
        GeometryReader { context in
            ZStack {
                VStack(alignment: .leading) {
                    if let url = URL(string: "https://api.lorem.space/image/movie?w=\(Int(context.size.width))&h=\(Int(context.size.height))") /*viewModel.movieDetail?.posterImage*/ {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } placeholder: {
                            ProgressView("Loading...")
                                .foregroundColor(.gray)
                                .font(.body)
                                .progressViewStyle(.automatic)
                                .frame(maxWidth: context.size.width,
                                       maxHeight: context.size.height)
                        }
                        .overlay {
                            GeometryReader { context in
                                ZStack(alignment: .bottomLeading) {
                                    Color(white: 0, opacity: 0.5)
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading) {
                                            Text(viewModel.movieDetail?.title ?? "NA")
                                                .lineLimit(1)
                                                .foregroundColor(Color.white)
                                                .font(.title)
                                            
                                            Text(viewModel.movieDetail?.releasedDate ?? "NA")
                                                .foregroundColor(Color.white)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                        }
                                        Spacer()
                                        UserRatingView(rating: viewModel.movieDetail?.rating ?? 0.0)
                                            .frame(width: 40, height: 40, alignment: .center)
                                    }
                                    .padding(8)
                                }
                            }
                        }
                    }
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
    
    private func toggleFavorite(_ newValue: Bool) {
        print("==== Updated value \(newValue)")
        if !newValue, let favorite = favorite.first {
            viewContext.delete(favorite)
        } else if let movie = viewModel.movieDetail {
            let favoriteMovie = Favorite(context: viewContext)
            favoriteMovie.title = movie.title
            favoriteMovie.releaseDate = movie.releasedDate
            favoriteMovie.id = Int32(movie.id)
            favoriteMovie.posterPath = movie.posterImage
            favoriteMovie.rating = movie.rating
        }
        try? viewContext.save()
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigurationContainer().makeMovieDetailScene(mediaID: 804150)
    }
}
