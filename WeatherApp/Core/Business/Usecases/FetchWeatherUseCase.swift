//
//  FetchWeatherUseCase.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - FetchWeatherUseCaseProtocol

protocol FetchWeatherUseCaseProtocol {
    func execute(cityName: String) async throws -> Weather
}

// MARK: - FetchWeatherUseCase

final class FetchWeatherUseCase: FetchWeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func execute(cityName: String) async throws -> Weather {
        guard !cityName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw WeatherDomainError.invalidCityName
        }

        return try await repository.fetchWeather(for: cityName)
    }
}

// MARK: - WeatherDomainError

enum WeatherDomainError: Error {
    case invalidCityName
    case cityNotFound
    case weatherNotFound

    var localizedDescription: String {
        switch self {
        case .invalidCityName:
            "Please enter a valid city name"
        case .cityNotFound:
            "City not found"
        case .weatherNotFound:
            "Weather information not available"
        }
    }
}
