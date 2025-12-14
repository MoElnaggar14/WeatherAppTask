//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, Weather App!")
        }
        #if DEBUG
        .debugMenu()
        #endif
    }
}

#Preview {
    ContentView()
}
