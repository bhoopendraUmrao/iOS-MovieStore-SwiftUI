//
//  CharacterListView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/24/23.
//

import SwiftUI

struct CharacterListView: View {
    var casts: [CharacterCast]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(casts, id: \.id) { cast in
                    CharacterView(character: cast)
                }
            }
        }
    }
}
