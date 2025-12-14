//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import CoreData
import SwiftUI

@main
struct WeatherAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
