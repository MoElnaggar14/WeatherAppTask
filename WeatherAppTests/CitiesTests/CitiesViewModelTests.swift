//
//  CitiesViewModelTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - CitiesViewModel Tests

@Suite("CitiesViewModel Tests")
@MainActor
struct CitiesViewModelTests {
    @Test("ViewModel initializes with empty state")
    func viewModelInitializesEmpty() {
        let viewModel = CitiesViewModel()

        #expect(viewModel.cities.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.selectedCity == nil)
    }

    @Test("Preview ViewModel has mock cities")
    func previewViewModelHasMockCities() {
        let viewModel = CitiesViewModel(isPreview: true, mockCities: City.mockCities)

        #expect(!viewModel.cities.isEmpty)
        #expect(viewModel.cities.count == City.mockCities.count)
    }

    @Test("Show weather detail for city updates state")
    func showWeatherDetailUpdatesState() {
        let city = City(name: "Test")
        let viewModel = CitiesViewModel(isPreview: true, mockCities: [city])

        viewModel.showWeatherDetailForCity(city)

        #expect(viewModel.selectedCity?.name == "Test")
        #expect(viewModel.showWeatherDetail)
    }

    @Test("Select city updates selected city")
    func selectCityUpdatesSelectedCity() {
        let city = City(name: "Selected")
        let viewModel = CitiesViewModel(isPreview: true, mockCities: [city])

        viewModel.selectCity(city)

        #expect(viewModel.selectedCity?.name == "Selected")
    }
}
