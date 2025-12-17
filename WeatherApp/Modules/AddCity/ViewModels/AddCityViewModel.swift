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
    private(set) var isAddingCity = false
    private(set) var error: Error?
    var showErrorToast = false
    var errorMessage = ""

    private var searchTask: Task<Void, Never>?
    private let fetchWeatherUseCase: FetchWeatherUseCaseProtocol
    private let addCityUseCase: AddCityUseCaseProtocol

    var appError: AppError? {
        guard let error else { return nil }
        return AppError.from(error)
    }

    var hasSearched: Bool {
        !searchQuery.isEmpty && searchQuery.count >= 2 && !isSearching
    }

    init(
        fetchWeatherUseCase: FetchWeatherUseCaseProtocol = FetchWeatherUseCase(),
        addCityUseCase: AddCityUseCaseProtocol = AddCityUseCase()
    ) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
        self.addCityUseCase = addCityUseCase
    }

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
            error = nil

            do {
                // Try to fetch weather for the query to validate it's a real location
                _ = try await fetchWeatherUseCase.execute(cityName: query)

                guard !Task.isCancelled else { return }

                // If successful, add to results
                searchResults = [query]
            } catch {
                guard !Task.isCancelled else { return }
                searchResults = []
                // Don't show error for search - just show no results
            }

            isSearching = false
        }
    }

    func addCity(name: String) async -> City? {
        isAddingCity = true
        error = nil

        do {
            let city = try await addCityUseCase.execute(cityName: name)
            isAddingCity = false
            return city
        } catch {
            self.error = error
            errorMessage = AppError.from(error).errorDescription ?? L10n.failedToAddCity
            showErrorToast = true
            isAddingCity = false
            return nil
        }
    }

    func clearError() {
        error = nil
        showErrorToast = false
    }
}
