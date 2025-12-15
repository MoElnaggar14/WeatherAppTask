//
//  FetchWeatherUseCaseTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - FetchWeatherUseCase Tests

@Suite("FetchWeatherUseCase Tests")
@MainActor
struct FetchWeatherUseCaseTests {
    @Test("Execute returns weather from repository")
    func executeReturnsWeather() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.fetchWeatherResult = Weather(
            description: "Sunny",
            temperature: 25,
            humidity: 40,
            iconCode: "01d",
            requestDate: Date()
        )

        let useCase = FetchWeatherUseCase(repository: mockRepository)
        let weather = try await useCase.execute(cityName: "London")

        #expect(weather.description == "Sunny")
        #expect(weather.temperature == 25)
    }

    @Test("Execute throws error for empty city name")
    func executeThrowsErrorForEmptyName() async throws {
        let mockRepository = MockWeatherRepository()
        let useCase = FetchWeatherUseCase(repository: mockRepository)

        await #expect(throws: WeatherDomainError.invalidCityName) {
            _ = try await useCase.execute(cityName: "   ")
        }
    }

    @Test("Execute throws error when repository fails")
    func executeThrowsError() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.shouldThrowError = true

        let useCase = FetchWeatherUseCase(repository: mockRepository)

        await #expect(throws: WeatherDomainError.self) {
            _ = try await useCase.execute(cityName: "London")
        }
    }
}
