//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @State private var settings = SettingsManager.shared

    var body: some View {
        CitiesListView()
            .preferredColorScheme(settings.themeMode.colorScheme)
        #if DEBUG
            .debugMenu()
        #endif
    }
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}
