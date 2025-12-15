//
//  CityEntityTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

@Suite("City Entity Tests")
@MainActor
struct CityEntityTests {
    @Test("City initializes with correct default values")
    func cityInitializesWithDefaults() {
        let city = City(name: "London")

        #expect(city.name == "London")
        #expect(city.weatherHistory.isEmpty)
        #expect(city.latestWeather == nil)
    }

    @Test("City returns latest weather correctly")
    func cityReturnsLatestWeather() {
        let oldWeather = Weather(
            description: "Cloudy",
            temperature: 15,
            humidity: 60,
            iconCode: "04d",
            requestDate: Date().addingTimeInterval(-3600)
        )
        let newWeather = Weather(
            description: "Sunny",
            temperature: 25,
            humidity: 40,
            iconCode: "01d",
            requestDate: Date()
        )

        let city = City(name: "Paris", weatherHistory: [oldWeather, newWeather])

        #expect(city.latestWeather?.description == "Sunny")
        #expect(city.latestWeather?.temperature == 25)
    }

    @Test("City adds weather correctly")
    func cityAddsWeather() {
        let city = City(name: "Tokyo")
        let weather = Weather(
            description: "Rainy",
            temperature: 18,
            humidity: 80,
            iconCode: "10d",
            requestDate: Date()
        )

        let updatedCity = city.addingWeather(weather)

        #expect(updatedCity.weatherHistory.count == 1)
        #expect(updatedCity.weatherHistory.first?.description == "Rainy")
    }

    @Test("City removes weather correctly")
    func cityRemovesWeather() {
        let weather = Weather(
            description: "Snowy",
            temperature: -5,
            humidity: 70,
            iconCode: "13d",
            requestDate: Date()
        )
        let city = City(name: "Moscow", weatherHistory: [weather])

        let updatedCity = city.removingWeather(withId: weather.id)

        #expect(updatedCity.weatherHistory.isEmpty)
    }

    @Test("City sorted weather history returns correct order")
    func citySortedWeatherHistory() {
        let oldWeather = Weather(
            description: "Cold",
            temperature: 5,
            humidity: 50,
            iconCode: "04d",
            requestDate: Date().addingTimeInterval(-7200)
        )
        let midWeather = Weather(
            description: "Mild",
            temperature: 15,
            humidity: 55,
            iconCode: "02d",
            requestDate: Date().addingTimeInterval(-3600)
        )
        let newWeather = Weather(
            description: "Warm",
            temperature: 25,
            humidity: 45,
            iconCode: "01d",
            requestDate: Date()
        )

        let city = City(name: "Berlin", weatherHistory: [oldWeather, newWeather, midWeather])
        let sorted = city.sortedWeatherHistory

        #expect(sorted.first?.description == "Warm")
        #expect(sorted.last?.description == "Cold")
    }
}
