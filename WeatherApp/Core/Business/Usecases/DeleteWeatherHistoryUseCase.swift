//
//  DeleteWeatherHistoryUseCase.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - DeleteWeatherHistoryUseCaseProtocol

protocol DeleteWeatherHistoryUseCaseProtocol {
    func execute(weather: Weather, from city: City) async throws
}

// MARK: - DeleteWeatherHistoryUseCase

final class DeleteWeatherHistoryUseCase: DeleteWeatherHistoryUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func execute(weather: Weather, from city: City) async throws {
        try await repository.deleteWeather(weather, from: city)
    }
}
