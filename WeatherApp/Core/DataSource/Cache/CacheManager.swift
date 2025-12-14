//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - CacheManager

final class CacheManager {
    enum SupportedStorage {
        case userDefaults
        case disk
    }

    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private lazy var userDefaultsStorage = UserDefaultsStorage()
    private lazy var diskStorage = DiskStorage()

    init(
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetch<T: Codable>(_: T.Type, for key: StorageKey) async throws -> T? {
        try await getSuitableStorage(from: key.suitableStorage).fetchValue(for: key)
    }

    func save(_ value: some Codable, for key: StorageKey) async throws {
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
            return userDefaultsStorage

        case .disk:
        }
    }
}
