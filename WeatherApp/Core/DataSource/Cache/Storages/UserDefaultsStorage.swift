//
//  UserDefaultsStorage.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - UserDefaultsStorage

final class UserDefaultsStorage {
    let defaults: UserDefaults = .standard
}

// MARK: WritableStorage

extension UserDefaultsStorage: WritableStorage {
    func save(value: some Codable, for key: StorageKey) async throws {
        defaults.set(value.encode, forKey: key.key)
    }

    func remove(type _: (some Codable).Type, for key: StorageKey) async throws {
        defaults.removeObject(forKey: key.key)
    }
}

// MARK: ReadableStorage

extension UserDefaultsStorage: ReadableStorage {
    func fetchValue<T: Codable>(for key: StorageKey) async throws -> T? {
        guard let value = defaults.data(forKey: key.key)?.decode(T.self) else {
            throw StorageError.notFound
        }
        return value
    }
}
