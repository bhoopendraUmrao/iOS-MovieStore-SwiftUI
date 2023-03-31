//
//  MovieListItemView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/23/23.
//

import SwiftUI

struct MovieListItemView: View {
    var movie:MovieListitemViewModel
    var namespace: Namespace.ID
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .leading) {
                GeometryReader { context in
                    if let url = movie.posterImage {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .clipped()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } placeholder: {
                            ProgressView("Loading..")
                                .foregroundColor(.gray)
                                .font(.body)
                                .progressViewStyle(.automatic)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .lineLimit(1)
                        .foregroundColor(Color.black)
                        .font(.headline)
                    
                    Text(movie.releaseDate)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .padding(8)
                .padding(.top, 12)
            }
            UserRatingView(rating: movie.rating ?? 0.0)
                .frame(width: 40, height: 40, alignment: .center)
                .padding(.bottom, 55)
                .padding(.leading, 8)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        .shadow(radius: 5)
    }
    
    var ratingView: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.black)
            Circle()
                .trim(from: 0, to: CGFloat((movie.rating ?? 0.0)) / 10)
                .stroke(
                    ratingColor,
                    lineWidth: 2
                )
                .rotationEffect(.degrees(-90))
                .padding(3)
            Text(String(format: "%.1f", movie.rating ?? 0.0))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    var ratingColor: Color {
        switch movie.rating ?? 0.0 {
        case 1..<6:
            return .red
        case 5..<7:
            return .orange
        default:
            return .green
        }
    }
}

struct MovieListItemView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        
        MovieListItemView(movie: MovieListitemViewModel(movie: Media(id: 1,
                                                                     title: "Mock",
                                                                     releaseDate: nil,
                                                                     overview: "Mock Overview",
                                                                     mediaType: .movie,
                                                                     genre: .adventure,
                                                                     rating: 5.8,
                                                                     language: "en_US",
                                                                     posterPath: "https://api.lorem.space/image/movie")), namespace: namespace)
    }
}
