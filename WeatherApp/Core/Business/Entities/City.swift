//
//  City.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - City

struct City: Identifiable, Equatable, Hashable, Sendable {
    let id: UUID
    let name: String
    let weatherHistory: [Weather]

    init(
        id: UUID = UUID(),
        name: String,
        weatherHistory: [Weather] = []
    ) {
        self.id = id
        self.name = name
        self.weatherHistory = weatherHistory
    }

    var latestWeather: Weather? {
        weatherHistory.sorted { $0.requestDate > $1.requestDate }.first
    }

    var sortedWeatherHistory: [Weather] {
        weatherHistory.sorted { $0.requestDate > $1.requestDate }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func addingWeather(_ weather: Weather) -> City {
        let filteredHistory = weatherHistory.filter { existing in
            !Calendar.current.isDate(existing.requestDate, equalTo: weather.requestDate, toGranularity: .minute)
        }

        return City(
            id: id,
            name: name,
            weatherHistory: filteredHistory + [weather]
        )
    }

    func removingWeather(withId weatherId: UUID) -> City {
        City(
            id: id,
            name: name,
            weatherHistory: weatherHistory.filter { $0.id != weatherId }
        )
    }
}

// MARK: - Mock Data

extension City {
    static let mockCities: [City] = [
        City(
            name: "London, UK",
            weatherHistory: [
                Weather(
                    description: "Cloudy",
                    temperature: 14,
                    humidity: 65,
                    iconCode: "04d",
                    requestDate: Date()
                ),
                Weather(
                    description: "Rainy",
                    temperature: 9,
                    humidity: 85,
                    iconCode: "10d",
                    requestDate: Date().addingTimeInterval(-86400)
                ),
            ]
        ),
        City(
            name: "Paris, France",
            weatherHistory: [
                Weather(
                    description: "Sunny",
                    temperature: 22,
                    humidity: 45,
                    iconCode: "01d",
                    requestDate: Date()
                ),
            ]
        ),
        City(
            name: "Tokyo, Japan",
            weatherHistory: [
                Weather(
                    description: "Clear",
                    temperature: 28,
                    humidity: 70,
                    iconCode: "01d",
                    requestDate: Date()
                ),
            ]
        ),
        City(
            name: "New York, USA",
            weatherHistory: []
        ),
        City(
            name: "Dubai, UAE",
            weatherHistory: [
                Weather(
                    description: "Hot",
                    temperature: 38,
                    humidity: 25,
                    iconCode: "01d",
                    requestDate: Date()
                ),
            ]
        ),
    ]

    static let mockCity: City = mockCities[0]
}
