//
//  City.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

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
