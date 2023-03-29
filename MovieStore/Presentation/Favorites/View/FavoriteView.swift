//
//  FavoriteView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/28/23.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var viewContext
    @State private var showLogin: Bool = false
    @FetchRequest(
      entity: Favorite.entity(),
      sortDescriptors: []
    ) var favorites: FetchedResults<Favorite>
    
    var body: some View {
        if appConfigurator.isUserLoggedIn {
            List(favorites) { item in
                Text(item.title ?? "Unknown")
            }
        } else {
            Button {
                showLogin.toggle()
            } label: {
                Text("Log In")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(height: 50)
                    .padding(.horizontal, 110)
                    .background(colorScheme == .dark ? .white : .black)
                    .cornerRadius(5)
            }
            .sheet(isPresented: $showLogin) {
                appConfigurator.makeLoginView()
            }
        }
    }
}

