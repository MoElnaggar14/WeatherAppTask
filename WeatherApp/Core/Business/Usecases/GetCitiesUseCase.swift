//
//  GetCitiesUseCase.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - GetCitiesUseCaseProtocol

protocol GetCitiesUseCaseProtocol {
    func execute(sortOrder: CitySortOrder) async throws -> [City]
}

// MARK: - CitySortOrder

enum CitySortOrder {
    case latest
    case oldest

    var isAscending: Bool {
        self == .oldest
    }
}

// MARK: - GetCitiesUseCase

final class GetCitiesUseCase: GetCitiesUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func execute(sortOrder: CitySortOrder = .latest) async throws -> [City] {
        let cities = try await repository.getAllCities()

        return cities.sorted { city1, city2 in
            let date1 = city1.latestWeather?.requestDate ?? Date.distantPast
            let date2 = city2.latestWeather?.requestDate ?? Date.distantPast
            return sortOrder.isAscending ? date1 < date2 : date1 > date2
        }
    }
}
