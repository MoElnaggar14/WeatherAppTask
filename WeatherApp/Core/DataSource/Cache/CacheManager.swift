//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - CacheManager

final class CacheManager: CacheManagerProtocol, @unchecked Sendable {
    enum SupportedStorage: Sendable {
        case userDefaults
        case disk
    }

    static let shared = CacheManager()

    private let userDefaultsStorage = UserDefaultsStorage()
    private let diskStorage = DiskStorage()

    init() { }

    func fetch<T: Codable & Sendable>(for key: StorageKey) async throws -> T? {
        switch key.suitableStorage {
        case .userDefaults:
            try await userDefaultsStorage.fetch(for: key)
        case .disk:
            try await diskStorage.fetch(for: key)
        }
    }

    func save(value: some Codable & Sendable, for key: StorageKey) async throws {
        switch key.suitableStorage {
        case .userDefaults:
            try await userDefaultsStorage.save(value: value, for: key)
        case .disk:
            try await diskStorage.save(value: value, for: key)
        }
    }

    func remove(type: (some Codable & Sendable).Type, for key: StorageKey) async throws {
        switch key.suitableStorage {
        case .userDefaults:
            try await userDefaultsStorage.remove(type: type, for: key)
        case .disk:
            try await diskStorage.remove(type: type, for: key)
        }
    }
}
