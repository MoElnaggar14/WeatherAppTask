//
//  GetCitiesUseCaseTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - GetCitiesUseCase Tests

@Suite("GetCitiesUseCase Tests")
@MainActor
struct GetCitiesUseCaseTests {
    @Test("Execute returns cities from repository")
    func executeReturnsCities() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.cities = City.mockCities

        let useCase = GetCitiesUseCase(repository: mockRepository)
        let cities = try await useCase.execute()

        #expect(!cities.isEmpty)
        #expect(cities.count == City.mockCities.count)
    }

    @Test("Execute returns empty array when no cities")
    func executeReturnsEmptyArray() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.cities = []

        let useCase = GetCitiesUseCase(repository: mockRepository)
        let cities = try await useCase.execute()

        #expect(cities.isEmpty)
    }

    @Test("Execute sorts cities by latest weather date descending")
    func executeSortsCitiesByLatestFirst() async throws {
        let mockRepository = MockWeatherRepository()

        let oldCity = City(
            name: "Old City",
            weatherHistory: [
                Weather(
                    description: "Old",
                    temperature: 10,
                    humidity: 50,
                    iconCode: "01d",
                    requestDate: Date().addingTimeInterval(-86400)
                ),
            ]
        )
        let newCity = City(
            name: "New City",
            weatherHistory: [
                Weather(
                    description: "New",
                    temperature: 20,
                    humidity: 60,
                    iconCode: "02d",
                    requestDate: Date()
                ),
            ]
        )
        mockRepository.cities = [oldCity, newCity]

        let useCase = GetCitiesUseCase(repository: mockRepository)
        let cities = try await useCase.execute(sortOrder: .latest)

        #expect(cities.first?.name == "New City")
        #expect(cities.last?.name == "Old City")
    }

    @Test("Execute throws error when repository fails")
    func executeThrowsError() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.shouldThrowError = true

        let useCase = GetCitiesUseCase(repository: mockRepository)

        await #expect(throws: WeatherDomainError.self) {
            _ = try await useCase.execute()
        }
    }
}
