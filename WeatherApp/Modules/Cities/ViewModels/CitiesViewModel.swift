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
    private(set) var isDeleting = false
    private(set) var error: Error?

    var selectedCity: City?
    var showAddCity = false
    var showWeatherDetail = false
    var showDeleteConfirmation = false
    var showSuccessToast = false
    var showErrorToast = false
    var successMessage = ""
    var errorMessage = ""

    private var cityToDelete: City?
    private let isPreview: Bool
    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let deleteCityUseCase: DeleteCityUseCaseProtocol

    var appError: AppError? {
        guard let error else { return nil }
        return AppError.from(error)
    }

    init(
        isPreview: Bool = false,
        mockCities: [City] = [],
        getCitiesUseCase: GetCitiesUseCaseProtocol = GetCitiesUseCase(),
        deleteCityUseCase: DeleteCityUseCaseProtocol = DeleteCityUseCase()
    ) {
        self.isPreview = isPreview
        self.getCitiesUseCase = getCitiesUseCase
        self.deleteCityUseCase = deleteCityUseCase
        if isPreview {
            cities = mockCities
        }
    }

    func loadCities() async {
        guard !isPreview else { return }

        isLoading = true
        error = nil

        do {
            cities = try await getCitiesUseCase.execute(sortOrder: .latest)
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func requestDeleteCity(_ city: City) {
        cityToDelete = city
        showDeleteConfirmation = true
    }

    func confirmDeleteCity() async {
        guard let city = cityToDelete else { return }

        guard !isPreview else {
            cities.removeAll { $0.id == city.id }
            cityToDelete = nil
            showDeleteConfirmation = false
            return
        }

        isDeleting = true
        error = nil

        do {
            try await deleteCityUseCase.execute(city: city)
            cities.removeAll { $0.id == city.id }
            cityToDelete = nil
            successMessage = "City deleted successfully"
            showSuccessToast = true
        } catch {
            self.error = error
            errorMessage = AppError.from(error).errorDescription ?? "Failed to delete city"
            showErrorToast = true
        }

        isDeleting = false
        showDeleteConfirmation = false
    }

    func cancelDelete() {
        cityToDelete = nil
        showDeleteConfirmation = false
    }

    func selectCity(_ city: City) {
        selectedCity = city
    }

    func showWeatherDetailForCity(_ city: City) {
        selectedCity = city
        showWeatherDetail = true
    }

    func clearError() {
        error = nil
    }
}
