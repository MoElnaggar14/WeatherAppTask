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
    private(set) var searchResults: [CitySearchResult] = []
    private(set) var isSearching = false
    private(set) var isAddingCity = false
    private(set) var error: Error?
    var showErrorToast = false
    var errorMessage = ""

    private var searchTask: Task<Void, Never>?
    private let searchCitiesUseCase: SearchCitiesUseCaseProtocol
    private let addCityUseCase: AddCityUseCaseProtocol

    var appError: AppError? {
        guard let error else { return nil }
        return AppError.from(error)
    }

    var hasSearched: Bool {
        !searchQuery.isEmpty && searchQuery.count >= 2 && !isSearching
    }

    init(
        searchCitiesUseCase: SearchCitiesUseCaseProtocol = SearchCitiesUseCase(),
        addCityUseCase: AddCityUseCaseProtocol = AddCityUseCase()
    ) {
        self.searchCitiesUseCase = searchCitiesUseCase
        self.addCityUseCase = addCityUseCase
    }

    func search(query: String) async {
        searchTask?.cancel()

        guard !query.isEmpty, query.count >= 2 else {
            searchResults = []
            return
        }

        searchTask = Task {
            // Debounce - 300ms
            try? await Task.sleep(nanoseconds: 300_000_000)

            guard !Task.isCancelled else { return }

            isSearching = true
            error = nil

            do {
                let results = try await searchCitiesUseCase.execute(query: query)

                guard !Task.isCancelled else { return }

                searchResults = results
            } catch {
                guard !Task.isCancelled else { return }
                searchResults = []
                // Don't show error for search - just show no results
            }

            isSearching = false
        }
    }

    func addCity(from searchResult: CitySearchResult) async -> City? {
        isAddingCity = true
        error = nil

        do {
            // Use the display name for better UX
            let city = try await addCityUseCase.execute(cityName: searchResult.displayName)
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
