//
//  WeatherRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - Weather Repository Protocol

protocol WeatherRepositoryProtocol: Sendable {
    /// Fetch current weather for a city
    func fetchWeather(for cityName: String) async throws -> Weather

    /// Get all saved cities
    func getAllCities() async throws -> [City]

    /// Get a specific city by name
    func getCity(byName name: String) async throws -> City?

    /// Save or update a city
    func saveCity(_ city: City) async throws

    /// Delete a city
    func deleteCity(_ city: City) async throws

    /// Add weather to a city (respects one-per-minute rule)
    func addWeather(_ weather: Weather, to city: City) async throws

    /// Delete specific weather from a city
    func deleteWeather(_ weather: Weather, from city: City) async throws
}
