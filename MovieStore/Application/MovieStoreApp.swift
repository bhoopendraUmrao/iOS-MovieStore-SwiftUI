//
//  MovieStoreApp.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 2/21/23.
//

import SwiftUI

@main
struct MovieStoreApp: App {
    private let appConfigurator = AppConfigurationContainer()
    @StateObject private var coreDataManager = CoreDataManager()
    var body: some Scene {
        WindowGroup {
            TabView {
                appConfigurator.makeTrendingScene()
                    .environmentObject(appConfigurator)
                    
                    .tabItem {
                        Label("Trending", systemImage: "book")
                    }
                FavoriteView()
                    .environmentObject(appConfigurator)
                    .tabItem {
                        Label("Favorite", systemImage: "star")
                    }
                SettingsView()
                    .environmentObject(appConfigurator)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)
            
        }
    }
}
