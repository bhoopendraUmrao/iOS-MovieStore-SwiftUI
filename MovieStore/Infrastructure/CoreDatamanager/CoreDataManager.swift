//
//  CoreDataManager.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/28/23.
//

import CoreData
import Foundation

final class CoreDataManager: ObservableObject {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "MovieStore")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core data store failed to initialize \(error.localizedDescription)")
            }
        }
    }
}
