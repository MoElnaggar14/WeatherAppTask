//
//  UserDefaultsStorage.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - UserDefaultsStorage

final class UserDefaultsStorage {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}

// MARK: WritableStorage

extension UserDefaultsStorage: WritableStorage {
    func save(value: some Codable, for key: StorageKey) async throws {
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: key.key)
        } catch {
            throw StorageError.encodingFailed(error)
        }
    }

    func remove(type _: (some Codable).Type, for key: StorageKey) async throws {
        defaults.removeObject(forKey: key.key)
    }
}

// MARK: ReadableStorage

extension UserDefaultsStorage: ReadableStorage {
    func fetch<T: Codable>(for key: StorageKey) async throws -> T? {
        guard let data = defaults.data(forKey: key.key) else {
            return nil
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed(error)
        }
    }
}
