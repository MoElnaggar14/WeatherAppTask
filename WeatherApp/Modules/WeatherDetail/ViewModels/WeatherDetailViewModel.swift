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

    private let fetchWeatherUseCase: FetchWeatherUseCaseProtocol
    private let isPreview: Bool

    var latestWeather: Weather? {
        fetchedWeather ?? city.latestWeather
    }

    var appError: AppError? {
        guard let error else { return nil }
        return AppError.from(error)
    }

    init(
        city: City,
        fetchWeatherUseCase: FetchWeatherUseCaseProtocol = FetchWeatherUseCase(),
        isPreview: Bool = false
    ) {
        self.city = city
        self.fetchWeatherUseCase = fetchWeatherUseCase
        self.isPreview = isPreview
    }

    func fetchWeather() async {
        guard !isPreview else { return }

        if
            let latest = city.latestWeather,
            Date().timeIntervalSince(latest.requestDate) < 60 { return }

        isLoading = true
        error = nil

        do {
            fetchedWeather = try await fetchWeatherUseCase.execute(cityName: city.name)
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func retry() async {
        error = nil
        await fetchWeather()
    }

    func clearError() {
        error = nil
    }
}
