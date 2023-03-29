//
//  SettingsView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/28/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    @Environment(\.colorScheme) var colorScheme
    @State private var showLogin: Bool = false
    var body: some View {
        Button {
            if appConfigurator.isUserLoggedIn {
                UserDefaults.standard.removeObject(forKey: "token")
                appConfigurator.logout()
            } else{
                showLogin.toggle()
            }
        } label: {
            Text(appConfigurator.isUserLoggedIn ? "Log Out" : "Log In")
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
