//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - CacheManager

final class CacheManager: Storage {
    enum SupportedStorage {
        case userDefaults
        case disk
    }

    static let shared = CacheManager()

    private lazy var userDefaultsStorage = UserDefaultsStorage()
    private lazy var diskStorage = DiskStorage()

    init() { }

    func fetch<T: Codable>(for key: StorageKey) async throws -> T? {
        try await getSuitableStorage(from: key.suitableStorage).fetch(for: key)
    }

    func save(value: some Codable, for key: StorageKey) async throws {
        try await getSuitableStorage(from: key.suitableStorage).save(value: value, for: key)
    }

    func remove(type: (some Codable).Type, for key: StorageKey) async throws {
        try await getSuitableStorage(from: key.suitableStorage).remove(type: type, for: key)
    }
}

private extension CacheManager {
    func getSuitableStorage(from choice: SupportedStorage) -> Storage {
        switch choice {
        case .userDefaults:
            userDefaultsStorage

        case .disk:
            diskStorage
        }
    }
}
