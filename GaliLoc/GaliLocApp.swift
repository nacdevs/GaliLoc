//
//  GaliLocApp.swift
//  GaliLoc
//
//  Created by Nestor Camela on 13/08/2025.
//

import SwiftUI
import Foundation

@main
struct GaliLocApp: App {
    let persistenceController = PersistenceController.shared
        init() {
            LocationManager.shared.configureCoreData(container: persistenceController.container)
            LocationManager.shared.startMonitoring()
            
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
