//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - WeatherRepository

final class WeatherRepository: WeatherRepositoryProtocol, @unchecked Sendable {
    private let networkManager: NetworkProtocol
    private let localDataSource: LocalDataSourceProtocol

    init(
        networkManager: NetworkProtocol = NetworkManager(),
        localDataSource: LocalDataSourceProtocol = CoreDataLocalDataSource()
    ) {
        self.networkManager = networkManager
        self.localDataSource = localDataSource
    }

    func fetchWeather(for cityName: String) async throws -> Weather {
        let response = try await networkManager.send(
            api: WeatherEndpoint.weather(city: cityName),
            model: WeatherResponse.self
        )
        return response.toDomain
    }

    func getAllCities() async throws -> [City] {
        try await localDataSource.getAllCities()
    }

    func getCity(byName name: String) async throws -> City? {
        try await localDataSource.getCity(byName: name)
    }

    func saveCity(_ city: City) async throws {
        try await localDataSource.saveCity(city)
    }

    func deleteCity(_ city: City) async throws {
        try await localDataSource.deleteCity(city)
    }

    func addWeather(_ weather: Weather, to city: City) async throws {
        let updatedCity = city.addingWeather(weather)
        try await localDataSource.saveCity(updatedCity)
    }

    func deleteWeather(_ weather: Weather, from city: City) async throws {
        let updatedCity = city.removingWeather(withId: weather.id)
        try await localDataSource.saveCity(updatedCity)
    }
}
