//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Observation

// MARK: - WeatherDetailViewModel

@MainActor
@Observable
final class WeatherDetailViewModel {
    let city: City
    private(set) var isLoading = false
    private(set) var error: Error?
    private(set) var fetchedWeather: Weather?

    var latestWeather: Weather? {
        fetchedWeather ?? city.latestWeather
    }

    init(city: City) {
        self.city = city
    }

    func fetchWeather() async {
        if
            let latest = city.latestWeather,
            Date().timeIntervalSince(latest.requestDate) < 60 { return }

        isLoading = true
        error = nil

        do {
            fetchedWeather = try await FetchWeatherUseCase().execute(cityName: city.name)
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
