//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - WeatherResponse

struct WeatherResponse: Codable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let name: String

    struct WeatherInfo: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct MainInfo: Codable {
        let temp: Double
        let humidity: Int
    }
}

extension WeatherResponse {
    var toDomain: Weather {
        let weatherInfo = weather.first ?? WeatherInfo(
            id: 0,
            main: "Unknown",
            description: "No data",
            icon: "01d"
        )

        let temperatureInCelsius = main.temp - 273.15

        return Weather(
            description: weatherInfo.description,
            temperature: temperatureInCelsius,
            humidity: main.humidity,
            iconCode: weatherInfo.icon,
            requestDate: Date()
        )
    }
}
