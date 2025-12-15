//
//  MockWeatherRepository.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - Mock Repository

@MainActor
final class MockWeatherRepository: WeatherRepositoryProtocol, @unchecked Sendable {
    var cities: [City] = []
    var shouldThrowError = false
    var fetchWeatherResult: Weather?

    func fetchWeather(for cityName: String) async throws -> Weather {
        if shouldThrowError {
            throw WeatherDomainError.cityNotFound
        }
        return fetchWeatherResult ?? Weather(
            description: "Cloudy",
            temperature: 20,
            humidity: 50,
            iconCode: "04d",
            requestDate: Date()
        )
    }

    func getAllCities() async throws -> [City] {
        if shouldThrowError {
            throw WeatherDomainError.cityNotFound
        }
        return cities
    }

    func getCity(byName name: String) async throws -> City? {
        cities.first { $0.name.lowercased() == name.lowercased() }
    }

    func saveCity(_ city: City) async throws {
        if shouldThrowError {
            throw WeatherDomainError.cityNotFound
        }
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index] = city
        } else {
            cities.append(city)
        }
    }

    func deleteCity(_ city: City) async throws {
        if shouldThrowError {
            throw WeatherDomainError.cityNotFound
        }
        cities.removeAll { $0.id == city.id }
    }

    func addWeather(_ weather: Weather, to city: City) async throws {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index] = city.addingWeather(weather)
        }
    }

    func deleteWeather(_ weather: Weather, from city: City) async throws {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index] = city.removingWeather(withId: weather.id)
        }
    }
}
