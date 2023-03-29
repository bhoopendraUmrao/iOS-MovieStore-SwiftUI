//
//  UserRatingView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/2/23.
//

import SwiftUI

struct UserRatingView: View {
    var rating: Float
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.black)
            Circle()
                .trim(from: 0, to: CGFloat((rating )) / 10)
                .stroke(
                    ratingColor,
                    lineWidth: 4
                )
                .rotationEffect(.degrees(-90))
                .padding(6)
            Text(String(format: "%.1f", rating ))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    var ratingColor: Color {
        switch rating {
        case 1..<6:
            return .red
        case 5..<7:
            return .orange
        default:
            return .green
        }
    }
}

struct UserRatingView_Previews: PreviewProvider {
    static var previews: some View {
        UserRatingView(rating: 7.2)
    }
}
