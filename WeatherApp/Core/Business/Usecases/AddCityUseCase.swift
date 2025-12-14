//
//  AddCityUseCase.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - AddCityUseCaseProtocol

protocol AddCityUseCaseProtocol {
    func execute(cityName: String) async throws -> City
}

// MARK: - AddCityUseCase

final class AddCityUseCase: AddCityUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol
    private let fetchWeatherUseCase: FetchWeatherUseCaseProtocol

    init(
        repository: WeatherRepositoryProtocol,
        fetchWeatherUseCase: FetchWeatherUseCaseProtocol
    ) {
        self.repository = repository
        self.fetchWeatherUseCase = fetchWeatherUseCase
    }

    func execute(cityName: String) async throws -> City {
        let trimmedName = cityName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            throw WeatherDomainError.invalidCityName
        }

        if let existingCity = try await repository.getCity(byName: trimmedName) {
            let weather = try await fetchWeatherUseCase.execute(cityName: trimmedName)
            let updatedCity = existingCity.addingWeather(weather)
            try await repository.saveCity(updatedCity)
            return updatedCity
        }

        let weather = try await fetchWeatherUseCase.execute(cityName: trimmedName)

        let newCity = City(name: trimmedName, weatherHistory: [weather])
        try await repository.saveCity(newCity)

        return newCity
    }
}
