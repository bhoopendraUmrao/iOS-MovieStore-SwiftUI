//
//  CircleBackButton.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/30/23.
//

import SwiftUI

struct CircleBackButton: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.backward")
                .imageScale(.large)
                .padding(8)
                .padding(.leading, 8)
                .foregroundColor(.white)
        }
        .background{
            Color.black
                .opacity(0.2)
        }
        .clipShape(Circle())
    }
}

struct CircleBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleBackButton()
    }
}
