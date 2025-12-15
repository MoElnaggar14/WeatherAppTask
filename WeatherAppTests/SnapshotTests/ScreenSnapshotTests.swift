//
//  ScreenSnapshotTests.swift
//  WeatherAppTests
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SnapshotTesting
import SwiftUI
import XCTest
@testable import WeatherApp

// MARK: - Screen Snapshot Tests

@MainActor
final class ScreenSnapshotTests: XCTestCase {
    // MARK: - CitiesListView

    func testCitiesListViewWithCities() {
        let viewModel = CitiesViewModel(isPreview: true, mockCities: City.mockCities)
        let view = CitiesListView(viewModel: viewModel)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testCitiesListViewEmpty() {
        let viewModel = CitiesViewModel(isPreview: true, mockCities: [])
        let view = CitiesListView(viewModel: viewModel)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - HistoricalWeatherView

    func testHistoricalWeatherViewWithHistory() {
        let city = City.mockCities[0] // London with weather history
        let view = HistoricalWeatherView(city: city)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testHistoricalWeatherViewEmpty() {
        let city = City(name: "Empty City", weatherHistory: [])
        let view = HistoricalWeatherView(city: city)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - WeatherDetailView

    func testWeatherDetailViewWithWeather() {
        let city = City.mockCities[0] // London with weather
        let view = WeatherDetailView(city: city)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testWeatherDetailViewNoWeather() {
        let city = City(name: "New City", weatherHistory: [])
        let view = WeatherDetailView(city: city)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - AddCityView

    func testAddCityView() {
        let view = AddCityView { _ in }
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - Device Variations

    func testCitiesListViewiPhoneSE() {
        let viewModel = CitiesViewModel(isPreview: true, mockCities: City.mockCities)
        let view = CitiesListView(viewModel: viewModel)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhoneSe)))
    }

    func testCitiesListViewiPhoneProMax() {
        let viewModel = CitiesViewModel(isPreview: true, mockCities: City.mockCities)
        let view = CitiesListView(viewModel: viewModel)
            .preferredColorScheme(.dark)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13ProMax)))
    }

    // MARK: - Light Mode

    func testCitiesListViewLightMode() {
        let viewModel = CitiesViewModel(isPreview: true, mockCities: City.mockCities)
        let view = CitiesListView(viewModel: viewModel)
            .preferredColorScheme(.light)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testWeatherDetailViewLightMode() {
        let city = City.mockCities[0]
        let view = WeatherDetailView(city: city)
            .preferredColorScheme(.light)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }
}
