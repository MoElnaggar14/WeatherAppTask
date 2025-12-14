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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
