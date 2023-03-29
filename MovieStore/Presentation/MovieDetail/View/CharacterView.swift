//
//  CharacterView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/24/23.
//

import SwiftUI

struct CharacterView: View {
    var character: CharacterCast
    var body: some View {
        VStack(alignment:.leading) {
            AsyncImage(
                url: character.image,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                }
            )
        }
        .background(Color.white)
        .frame(maxWidth: .infinity, maxHeight: 160)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(character: .init(id: 213421, name: "Keanu Reeves", characterName: "John Wick", image: URL(string: "www.google.com")))
    }
}
