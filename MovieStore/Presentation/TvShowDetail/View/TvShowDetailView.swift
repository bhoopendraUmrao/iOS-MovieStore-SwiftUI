//
//  TvShowDetailView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/17/23.
//

import SwiftUI

struct TvShowDetailView<TVShowDetailVM>: View where TVShowDetailVM: TvShowDetailViewModel {
    @ObservedObject var viewModel: TVShowDetailVM
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack(alignment: .top) {
                    postImage
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.tvShowDetail?.title ?? "NA")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.headline)
                        Text(viewModel.tvShowDetail?.releasedDate ?? "NA")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor.lightGray))
                            .fontWeight(.semibold)
                        HStack(alignment: .top) {
                            UserRatingView(rating: viewModel.tvShowDetail?.rating ?? 0.0)
                                .frame(width: 50, height: 50, alignment: .top)
                        }
                        .padding(.vertical, 4)
                        
                        VStack(alignment: .leading) {
                            Text("Last Episode:")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(viewModel.tvShowDetail?.lastAirDate ?? "NA")
                        }
                        .padding(.bottom, 8)
                        
                        VStack(alignment: .leading) {
                            Text("Next Episode:")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(viewModel.tvShowDetail?.nextEpisodeAirDate ?? "NA")
                        }
                        .padding(.bottom, 8)
                        
                        VStack(alignment: .leading) {
                            Text("Network:")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(viewModel.tvShowDetail?.network ?? "NA")
                        }
                        .padding(.bottom, 0)
                    }
                    .padding(.trailing, 16)
                }
                tagline
                Group {
                    Text("Overview")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(viewModel.tvShowDetail?.overview ?? "NA")
                        .lineSpacing(1.5)
                        .font(.body)
                    HStack(alignment: .top) {
                        Text("Geners: ")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(viewModel.tvShowDetail?.geners.compactMap{$0.name}.joined(separator: ", ") ?? "NA")
                    }
                    
                    HVideoListView(videoList: viewModel.videoList)
                    
                    HStack(alignment: .top) {
                        Text("Language: ")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(viewModel.tvShowDetail?.audioLanguage ?? "NA")
                    }
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
        .foregroundColor(.white)
        .background(
            AngularGradient(gradient: Gradient(colors: [.white, .black]),
                            center: .bottomTrailing,
                            startAngle: .zero,
                            endAngle: .degrees(360))
        )
        
    }
    
    private var postImage: some View {
        ZStack {
            AsyncImage(url: viewModel.tvShowDetail?.posterImage) { image in
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
        Text(viewModel.tvShowDetail?.tagline ?? "NA")
            .italic()
            .font(.callout)
            .foregroundColor(Color(UIColor.lightGray))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
    }
}

//struct TvShowDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TvShowDetailView(viewModel: <#_#>)
//    }
//}
