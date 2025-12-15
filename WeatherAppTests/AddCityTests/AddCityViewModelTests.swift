//
//  AddCityViewModelTests.swift
//  WeatherAppTests
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - AddCityViewModel Tests

@Suite("AddCityViewModel Tests")
@MainActor
struct AddCityViewModelTests {
    // MARK: - Initialization Tests

    @Test("ViewModel initializes with empty state")
    func viewModelInitializesEmpty() {
        let mockRepository = MockWeatherRepository()
        let viewModel = AddCityViewModel(
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository),
            addCityUseCase: AddCityUseCase(
                repository: mockRepository,
                fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
            )
        )

        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
        #expect(!viewModel.isSearching)
    }

    // MARK: - Search Tests

    @Test("Search with empty query clears results")
    func searchWithEmptyQueryClearsResults() async {
        let mockRepository = MockWeatherRepository()
        let viewModel = AddCityViewModel(
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository),
            addCityUseCase: AddCityUseCase(
                repository: mockRepository,
                fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
            )
        )

        await viewModel.search(query: "")

        #expect(viewModel.searchResults.isEmpty)
    }

    @Test("Search with short query (less than 2 chars) clears results")
    func searchWithShortQueryClearsResults() async {
        let mockRepository = MockWeatherRepository()
        let viewModel = AddCityViewModel(
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository),
            addCityUseCase: AddCityUseCase(
                repository: mockRepository,
                fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
            )
        )

        await viewModel.search(query: "L")

        #expect(viewModel.searchResults.isEmpty)
    }

    @Test("Search with valid query returns results")
    func searchWithValidQueryReturnsResults() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "Sunny",
            temperature: 25,
            humidity: 50,
            iconCode: "01d",
            requestDate: Date()
        )

        let viewModel = AddCityViewModel(
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository),
            addCityUseCase: AddCityUseCase(
                repository: mockRepository,
                fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
            )
        )

        await viewModel.search(query: "London")

        // Wait for debounce (300ms) + execution time
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(viewModel.searchResults.contains("London"))
    }

    @Test("Search with invalid city returns empty results")
    func searchWithInvalidCityReturnsEmptyResults() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.shouldThrowError = true

        let viewModel = AddCityViewModel(
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository),
            addCityUseCase: AddCityUseCase(
                repository: mockRepository,
                fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
            )
        )

        await viewModel.search(query: "InvalidCity12345")

        // Wait for debounce
        try await Task.sleep(nanoseconds: 400_000_000)

        #expect(viewModel.searchResults.isEmpty)
    }

    // MARK: - Add City Tests

    @Test("Add city successfully returns city")
    func addCitySuccessfullyReturnsCity() async {
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "Cloudy",
            temperature: 18,
            humidity: 65,
            iconCode: "04d",
            requestDate: Date()
        )

        let viewModel = AddCityViewModel(
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository),
            addCityUseCase: AddCityUseCase(
                repository: mockRepository,
                fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
            )
        )

        let city = await viewModel.addCity(name: "Paris")

        #expect(city != nil)
        #expect(city?.name == "Paris")
        #expect(mockRepository.cities.contains { $0.name == "Paris" })
    }

    @Test("Add city with error returns nil")
    func addCityWithErrorReturnsNil() async {
        let mockRepository = MockWeatherRepository()
        mockRepository.shouldThrowError = true

        let viewModel = AddCityViewModel(
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository),
            addCityUseCase: AddCityUseCase(
                repository: mockRepository,
                fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
            )
        )

        let city = await viewModel.addCity(name: "Test")

        #expect(city == nil)
    }
}
