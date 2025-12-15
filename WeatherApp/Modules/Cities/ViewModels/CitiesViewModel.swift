//
//  CitiesViewModel.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Observation

// MARK: - CitiesViewModel

@MainActor
@Observable
final class CitiesViewModel {
    private(set) var cities: [City] = []
    private(set) var isLoading = false
    private(set) var error: Error?

    var selectedCity: City?
    var showAddCity = false
    var showWeatherDetail = false

    func loadCities() async {
        isLoading = true
        error = nil

        do {
            cities = try await GetCitiesUseCase().execute()
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func deleteCity(_ city: City) async {
        do {
            try await DeleteCityUseCase().execute(city: city)
            cities.removeAll { $0.id == city.id }
        } catch {
            self.error = error
        }
    }

    func selectCity(_ city: City) {
        selectedCity = city
    }

    func showWeatherDetailForCity(_ city: City) {
        selectedCity = city
        showWeatherDetail = true
    }
}
