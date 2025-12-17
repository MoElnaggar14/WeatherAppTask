//
//  SearchCitiesUseCase.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - SearchCitiesUseCaseProtocol

protocol SearchCitiesUseCaseProtocol {
    func execute(query: String) async throws -> [CitySearchResult]
}

// MARK: - SearchCitiesUseCase

final class SearchCitiesUseCase: SearchCitiesUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol
    private let limit: Int

    init(
        repository: WeatherRepositoryProtocol = WeatherRepository(),
        limit: Int = 5
    ) {
        self.repository = repository
        self.limit = limit
    }

    func execute(query: String) async throws -> [CitySearchResult] {
        guard query.count >= 2 else {
            return []
        }

        let results = try await repository.searchCities(query: query, limit: limit)

        // Filter out duplicates based on display name
        var seen = Set<String>()
        return results.filter { result in
            let key = result.displayName.lowercased()
            if seen.contains(key) {
                return false
            }
            seen.insert(key)
            return true
        }
    }
}
