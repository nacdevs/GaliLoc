//
//  PersistanceController.swift
//  GaliLoc
//
//  Created by Nestor Camela on 13/08/2025.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Constants.PersistentConstainer)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error cargando Core Data: \(error)")
            }
        }
    }
}


struct Constants{
    static let baseURL = "https://www.mocklicia.com/"
    static let PersistentConstainer = "Model"
    static let LocationEntity = "LocationEntity"
}
