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
    @Environment(\.dismiss) private var dismiss
    @FetchRequest var favorite: FetchedResults<Favorite>
    @State var show: Bool = false
    init(movieId: Int32, viewModel: MovieDetailVM) {
        _favorite = FetchRequest<Favorite>(entity: Favorite.entity(),
                                           sortDescriptors: [],
                                           predicate: NSPredicate(format: "id == %@",argumentArray: [movieId]))
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            movieBanner
                .frame(height: UIScreen.main.bounds.height*0.34)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Group {
                        Text("Overview")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(viewModel.movieDetail?.overview ?? "NA")
                            .lineSpacing(1.5)
                            .font(.body)
                            .padding(.vertical, 0)
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
                    .padding(8)
                }
            }
            Spacer()
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.didFetch()
        }
    }
    
    private var movieBanner: some View {
        GeometryReader { context in
            ZStack {
                VStack(alignment: .leading) {
                    if let url = viewModel.movieDetail?.posterImage {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: context.size.width,
                                       maxHeight: context.size.width - 100)
                                .clipped()
                        } placeholder: {
                            ProgressView("Loading...")
                                .foregroundColor(.gray)
                                .font(.body)
                                .progressViewStyle(.automatic)
                                .frame(maxWidth: context.size.width,
                                       maxHeight: context.size.width - 100)
                        }
                        .overlay {
                            GeometryReader { context in
                                ZStack(alignment: .topLeading) {
                                    backButton
                                        .padding(.top, context.size.height*0.2)
                                        .padding(.leading, 4)
                                    ZStack {
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
                                    }
                                    .padding(.top, context.size.height/2 + 50)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.backward")
                .imageScale(.large)
                .foregroundColor(.white)
                .padding()
                .background{
                    Color.black
                        .opacity(0.2)
                }
                .clipShape(Circle())
        }
    }
    
    private var favoriteButton: some View {
        Button(action: {
            if appConfigurator.isUserLoggedIn {
                if let favorite = favorite.first {
                    viewContext.delete(favorite)
                } else {
                    let favoriteMovie = Favorite(context: viewContext)
                    favoriteMovie.title = viewModel.movieDetail?.title
                    favoriteMovie.releaseDate = viewModel.movieDetail?.releasedDate
                    favoriteMovie.id = Int32(viewModel.movieDetail?.id ?? 0)
                    favoriteMovie.posterPath = viewModel.movieDetail?.posterImage
                    favoriteMovie.rating = viewModel.movieDetail?.rating ?? 0.0
                }
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
