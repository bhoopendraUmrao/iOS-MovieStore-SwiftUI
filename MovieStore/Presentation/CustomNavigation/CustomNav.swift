//
//  CustomNav.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/29/23.
//

import SwiftUI

struct CustomNav: View {
    @Namespace var namespace
    @State var show: Bool = true
    var body: some View {
        if !show {
            MovieListItemView(movie:  .init(id: 1, title: "Test", releaseDate: "11/02/2022", overview: "Test name", posterImage: URL(string: "https://api.lorem.space/image/movie?w=400&h=400"), rating: 4.0), namespace: namespace)
                .frame(height: 400)
                .padding(8)
                .onTapGesture {
                    show.toggle()
                }
        } else {
            ZStack(alignment: .bottomLeading) {
                GeometryReader { context in
                    VStack(alignment: .leading) {
                        if let url = URL(string: "https://api.lorem.space/image/movie?w=\(Int(context.size.width))&h=\(Int(context.size.width - 100))") {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(maxWidth: context.size.width, maxHeight: context.size.width - 100)
                            } placeholder: {
                                ProgressView("Loading...")
                                    .foregroundColor(.gray)
                                    .font(.body)
                                    .progressViewStyle(.automatic)
                                    .frame(maxWidth: context.size.width, maxHeight: context.size.width - 100)
                            }
                            .overlay {
                                GeometryReader { context in
                                    ZStack {
                                        Color(white: 0, opacity: 0.5)
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                Text("Test")
                                                    .lineLimit(1)
                                                    .foregroundColor(Color.white)
                                                    .font(.title)
                                                Text("11/02/2022")
                                                    .foregroundColor(Color.white)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                            }
                                            Spacer()
                                            UserRatingView(rating: 4.0)
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
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            .shadow(radius: 5)
            .onTapGesture {
                show.toggle()
            }
        }
        
    }
    
    var ratingView: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.black)
            Circle()
                .trim(from: 0, to: CGFloat((4.0)) / 10)
                .stroke(
                    ratingColor,
                    lineWidth: 2
                )
                .rotationEffect(.degrees(-90))
                .padding(3)
            Text(String(format: "%.1f", 4.0 ))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    var ratingColor: Color {
        switch 4.0 {
        case 1..<6:
            return .red
        case 5..<7:
            return .orange
        default:
            return .green
        }
    }
}


struct CustomNav_Previews: PreviewProvider {
    static var previews: some View {
        CustomNav()
    }
}
