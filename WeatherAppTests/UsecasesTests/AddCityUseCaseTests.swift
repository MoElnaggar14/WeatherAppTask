//
//  AddCityUseCaseTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - AddCityUseCase Tests

@Suite("AddCityUseCase Tests")
@MainActor
struct AddCityUseCaseTests {
    @Test("Execute adds new city with weather")
    func executeAddsNewCity() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "Cloudy",
            temperature: 18,
            humidity: 70,
            iconCode: "04d",
            requestDate: Date()
        )

        let useCase = AddCityUseCase(
            repository: mockRepository,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )
        let city = try await useCase.execute(cityName: "Paris")

        #expect(city.name == "Paris")
        #expect(!city.weatherHistory.isEmpty)
        #expect(mockRepository.cities.contains { $0.name == "Paris" })
    }

    @Test("Execute throws error for empty city name")
    func executeThrowsErrorForEmptyName() async throws {
        let mockRepository = MockWeatherRepository()
        let useCase = AddCityUseCase(
            repository: mockRepository,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )

        await #expect(throws: WeatherDomainError.invalidCityName) {
            _ = try await useCase.execute(cityName: "")
        }
    }

    @Test("Execute updates existing city with new weather")
    func executeUpdatesExistingCity() async throws {
        let mockRepository = MockWeatherRepository()
        let existingWeather = Weather(
            description: "Old",
            temperature: 15,
            humidity: 60,
            iconCode: "03d",
            requestDate: Date().addingTimeInterval(-3600)
        )
        let existingCity = City(name: "London", weatherHistory: [existingWeather])
        mockRepository.cities = [existingCity]

        mockRepository.fetchWeatherResult = Weather(
            description: "New",
            temperature: 20,
            humidity: 50,
            iconCode: "01d",
            requestDate: Date()
        )

        let useCase = AddCityUseCase(
            repository: mockRepository,
            fetchWeatherUseCase: FetchWeatherUseCase(repository: mockRepository)
        )
        let updatedCity = try await useCase.execute(cityName: "London")

        #expect(updatedCity.weatherHistory.count == 2)
        #expect(updatedCity.latestWeather?.description == "New")
    }
}
