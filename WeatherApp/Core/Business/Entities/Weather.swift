//
//  Weather.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - Weather Entity

struct Weather: Identifiable, Equatable, Sendable {
    let id: UUID
    let description: String
    let temperature: Double
    let humidity: Int
    let iconCode: String
    let requestDate: Date

    init(
        id: UUID = UUID(),
        description: String,
        temperature: Double,
        humidity: Int,
        iconCode: String,
        requestDate: Date = Date()
    ) {
        self.id = id
        self.description = description
        self.temperature = temperature
        self.humidity = humidity
        self.iconCode = iconCode
        self.requestDate = requestDate
    }

    var iconURL: URL? {
        URL(string: "http://openweathermap.org/img/w/\(iconCode).png")
    }

    var formattedTemperature: String {
        String(format: "%.1f°C", temperature)
    }

    var formattedHumidity: String {
        "\(humidity)%"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: requestDate)
    }
}
