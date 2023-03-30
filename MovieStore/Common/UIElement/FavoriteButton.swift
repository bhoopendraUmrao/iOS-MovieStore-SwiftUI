//
//  FavoriteButton.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/30/23.
//

import SwiftUI

struct FavoriteButton: View {
    @State var showingLogin: Bool = false
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    @Binding var isSelected: Bool
    var body: some View {
        Button {
            if appConfigurator.isUserLoggedIn {
                isSelected.toggle()
            } else {
                showingLogin.toggle()
            }
        } label: {
            Image(systemName: isSelected ? "star.fill" : "star")
                .imageScale(.medium)
                .padding(8)
                .padding(.trailing, 8)
                .foregroundColor(Color(.displayP3, red: 227.0, green: 190.0, blue: 0.0, opacity: 1.0))
        }
        .background{
            Color.black
                .opacity(0.2)
        }
        .clipShape(Circle())
        .sheet(isPresented: $showingLogin) {
            appConfigurator.makeLoginView()
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSelected: .constant(true))
    }
}
