//
//  AddCityViewModel.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Observation

// MARK: - AddCityViewModel

@MainActor
@Observable
final class AddCityViewModel {
    var searchQuery = ""
    private(set) var searchResults: [String] = []
    private(set) var isSearching = false
    private(set) var error: Error?

    private var searchTask: Task<Void, Never>?

    func search(query: String) async {
        searchTask?.cancel()

        guard !query.isEmpty, query.count >= 2 else {
            searchResults = []
            return
        }

        searchTask = Task {
            // Debounce
            try? await Task.sleep(nanoseconds: 300_000_000)

            guard !Task.isCancelled else { return }

            isSearching = true

            do {
                // Try to fetch weather for the query to validate it's a real location
                _ = try await FetchWeatherUseCase().execute(cityName: query)

                guard !Task.isCancelled else { return }

                // If successful, add to results
                searchResults = [query]
            } catch {
                guard !Task.isCancelled else { return }
                searchResults = []
            }

            isSearching = false
        }
    }

    func addCity(name: String) async -> City? {
        do {
            return try await AddCityUseCase().execute(cityName: name)
        } catch {
            self.error = error
            return nil
        }
    }
}
