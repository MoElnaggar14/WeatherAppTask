//
//  WeatherEntityTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - Weather Entity Tests

@Suite("Weather Entity Tests")
@MainActor
struct WeatherEntityTests {
    @Test("Weather initializes with correct values")
    func weatherInitializesCorrectly() {
        let weather = Weather(
            description: "Cloudy",
            temperature: 20.5,
            humidity: 65,
            iconCode: "04d",
            requestDate: Date()
        )

        #expect(weather.description == "Cloudy")
        #expect(weather.temperature == 20.5)
        #expect(weather.humidity == 65)
        #expect(weather.iconCode == "04d")
    }

    @Test("Weather formats temperature correctly")
    func weatherFormatsTemperature() {
        let weather = Weather(
            description: "Test",
            temperature: 20.567,
            humidity: 50,
            iconCode: "01d",
            requestDate: Date()
        )

        #expect(weather.formattedTemperature == "20.6°C")
    }

    @Test("Weather formats humidity correctly")
    func weatherFormatsHumidity() {
        let weather = Weather(
            description: "Test",
            temperature: 20,
            humidity: 75,
            iconCode: "01d",
            requestDate: Date()
        )

        #expect(weather.formattedHumidity == "75%")
    }

    @Test("Weather generates correct icon URL")
    func weatherIconURL() {
        let weather = Weather(
            description: "Test",
            temperature: 20,
            humidity: 50,
            iconCode: "10d",
            requestDate: Date()
        )

        #expect(weather.iconURL?.absoluteString == "http://openweathermap.org/img/w/10d.png")
    }
}
