//
//  HistoricalWeatherViewModel.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Observation

// MARK: - HistoricalWeatherViewModel

@MainActor
@Observable
final class HistoricalWeatherViewModel {
    private(set) var city: City
    private(set) var isLoading = false
    private(set) var isDeleting = false
    var error: AppError?
    var showDeleteConfirmation = false
    var weatherToDelete: Weather?
    var showSuccessToast = false
    var successMessage = ""
    var selectedWeather: Weather?
    var showWeatherDetail = false

    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let deleteWeatherHistoryUseCase: DeleteWeatherHistoryUseCaseProtocol
    private let isPreview: Bool

    var weatherHistory: [Weather] {
        city.sortedWeatherHistory
    }

    init(
        city: City,
        getCitiesUseCase: GetCitiesUseCaseProtocol = GetCitiesUseCase(),
        deleteWeatherHistoryUseCase: DeleteWeatherHistoryUseCaseProtocol = DeleteWeatherHistoryUseCase(),
        isPreview: Bool = false
    ) {
        self.city = city
        self.getCitiesUseCase = getCitiesUseCase
        self.deleteWeatherHistoryUseCase = deleteWeatherHistoryUseCase
        self.isPreview = isPreview
    }

    func refreshCity() async {
        guard !isPreview else { return }

        isLoading = true
        error = nil

        do {
            let cities = try await getCitiesUseCase.execute(sortOrder: .latest)
            if let updatedCity = cities.first(where: { $0.id == city.id }) {
                city = updatedCity
            }
        } catch {
            self.error = AppError.from(error)
        }

        isLoading = false
    }

    func confirmDelete(_ weather: Weather) {
        weatherToDelete = weather
        showDeleteConfirmation = true
    }

    func deleteWeather() async {
        guard let weather = weatherToDelete else { return }
        guard !isPreview else {
            city = city.removingWeather(withId: weather.id)
            weatherToDelete = nil
            return
        }

        isDeleting = true
        error = nil

        do {
            try await deleteWeatherHistoryUseCase.execute(weather: weather, from: city)
            city = city.removingWeather(withId: weather.id)
            weatherToDelete = nil
            successMessage = "Weather record deleted"
            showSuccessToast = true
        } catch {
            self.error = .deleteFailed
        }

        isDeleting = false
    }

    func cancelDelete() {
        weatherToDelete = nil
        showDeleteConfirmation = false
    }

    func clearError() {
        error = nil
    }

    func selectWeather(_ weather: Weather) {
        selectedWeather = weather
        showWeatherDetail = true
    }
}
