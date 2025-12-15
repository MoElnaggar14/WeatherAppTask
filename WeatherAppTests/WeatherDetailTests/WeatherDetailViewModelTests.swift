//
//  WeatherDetailViewModelTests.swift
//  WeatherAppTests
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - WeatherDetailViewModel Tests

@Suite("WeatherDetailViewModel Tests")
@MainActor
struct WeatherDetailViewModelTests {
    // MARK: - Initialization Tests

    @Test("ViewModel initializes with city")
    func viewModelInitializesWithCity() {
        let city = City(name: "London")
        let mockRepository = MockWeatherRepository()

        let viewModel = WeatherDetailViewModel(
            city: city,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        #expect(viewModel.city.name == "London")
        #expect(!viewModel.isLoading)
        #expect(viewModel.fetchedWeather == nil)
    }

    @Test("ViewModel returns city's latest weather when no fetched weather")
    func viewModelReturnsCityLatestWeather() {
        let weather = Weather(
            description: "Sunny",
            temperature: 25,
            humidity: 50,
            iconCode: "01d",
            requestDate: Date()
        )
        let city = City(name: "Paris", weatherHistory: [weather])
        let mockRepository = MockWeatherRepository()

        let viewModel = WeatherDetailViewModel(
            city: city,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        #expect(viewModel.latestWeather?.description == "Sunny")
        #expect(viewModel.latestWeather?.temperature == 25)
    }

    // MARK: - Fetch Weather Tests

    @Test("Fetch weather updates fetchedWeather")
    func fetchWeatherUpdatesFetchedWeather() async {
        let city = City(name: "Tokyo")
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "Rainy",
            temperature: 18,
            humidity: 80,
            iconCode: "10d",
            requestDate: Date()
        )

        let viewModel = WeatherDetailViewModel(
            city: city,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        await viewModel.fetchWeather()

        #expect(viewModel.fetchedWeather != nil)
        #expect(viewModel.fetchedWeather?.description == "Rainy")
        #expect(viewModel.fetchedWeather?.temperature == 18)
    }

    @Test("Fetch weather skipped if recent weather exists (within 60 seconds)")
    func fetchWeatherSkippedIfRecentWeatherExists() async {
        let recentWeather = Weather(
            description: "Clear",
            temperature: 22,
            humidity: 45,
            iconCode: "01d",
            requestDate: Date() // Current time
        )
        let city = City(name: "Berlin", weatherHistory: [recentWeather])
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "Should Not Fetch",
            temperature: 0,
            humidity: 0,
            iconCode: "01d",
            requestDate: Date()
        )

        let viewModel = WeatherDetailViewModel(
            city: city,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        await viewModel.fetchWeather()

        // Should not fetch because weather is recent
        #expect(viewModel.fetchedWeather == nil)
        #expect(viewModel.latestWeather?.description == "Clear")
    }

    @Test("Fetch weather executes if weather is old (more than 60 seconds)")
    func fetchWeatherExecutesIfWeatherIsOld() async {
        let oldWeather = Weather(
            description: "Old",
            temperature: 15,
            humidity: 60,
            iconCode: "04d",
            requestDate: Date().addingTimeInterval(-120) // 2 minutes ago
        )
        let city = City(name: "Madrid", weatherHistory: [oldWeather])
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "New",
            temperature: 20,
            humidity: 50,
            iconCode: "01d",
            requestDate: Date()
        )

        let viewModel = WeatherDetailViewModel(
            city: city,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        await viewModel.fetchWeather()

        #expect(viewModel.fetchedWeather?.description == "New")
    }

    @Test("Fetch weather with error sets error state")
    func fetchWeatherWithErrorSetsErrorState() async {
        let city = City(name: "Unknown")
        let mockRepository = MockWeatherRepository()
        mockRepository.shouldThrowError = true

        let viewModel = WeatherDetailViewModel(
            city: city,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        await viewModel.fetchWeather()

        #expect(!viewModel.isLoading)
        #expect(viewModel.fetchedWeather == nil)
    }

    @Test("Latest weather returns fetched weather over city weather")
    func latestWeatherReturnsFetchedWeatherOverCityWeather() async {
        let oldWeather = Weather(
            description: "Old City Weather",
            temperature: 10,
            humidity: 70,
            iconCode: "04d",
            requestDate: Date().addingTimeInterval(-3600)
        )
        let city = City(name: "Rome", weatherHistory: [oldWeather])
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "New Fetched Weather",
            temperature: 25,
            humidity: 45,
            iconCode: "01d",
            requestDate: Date()
        )

        let viewModel = WeatherDetailViewModel(
            city: city,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        // Before fetch, should return city's weather
        #expect(viewModel.latestWeather?.description == "Old City Weather")

        await viewModel.fetchWeather()

        // After fetch, should return fetched weather
        #expect(viewModel.latestWeather?.description == "New Fetched Weather")
    }
}
