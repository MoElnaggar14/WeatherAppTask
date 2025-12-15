//
//  DeleteCityUseCaseTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - DeleteCityUseCase Tests

@Suite("DeleteCityUseCase Tests")
@MainActor
struct DeleteCityUseCaseTests {
    @Test("Execute deletes city from repository")
    func executeDeletesCity() async throws {
        let mockRepository = MockWeatherRepository()
        let city = City(name: "ToDelete")
        mockRepository.cities = [city]

        let useCase = DeleteCityUseCase(repository: mockRepository)
        try await useCase.execute(city: city)

        #expect(mockRepository.cities.isEmpty)
    }

    @Test("Execute throws error when repository fails")
    func executeThrowsError() async throws {
        let mockRepository = MockWeatherRepository()
        mockRepository.shouldThrowError = true
        let city = City(name: "Test")

        let useCase = DeleteCityUseCase(repository: mockRepository)

        await #expect(throws: WeatherDomainError.self) {
            try await useCase.execute(city: city)
        }
    }
}
