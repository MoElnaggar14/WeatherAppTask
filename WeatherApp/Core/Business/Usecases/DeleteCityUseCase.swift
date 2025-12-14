//
//  DeleteCityUseCase.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - DeleteCityUseCaseProtocol

protocol DeleteCityUseCaseProtocol {
    func execute(city: City) async throws
}

// MARK: - DeleteCityUseCase

final class DeleteCityUseCase: DeleteCityUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute(city: City) async throws {
        try await repository.deleteCity(city)
    }
}
