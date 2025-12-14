//
//  UserDefaultsStorage.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - UserDefaultsStorage

actor UserDefaultsStorage {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetch<T: Codable & Sendable>(for key: StorageKey) throws -> T? {
        guard let data = defaults.data(forKey: key.key) else {
            return nil
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed(error)
        }
    }

    func save(value: some Codable & Sendable, for key: StorageKey) throws {
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: key.key)
        } catch {
            throw StorageError.encodingFailed(error)
        }
    }

    func remove(type _: (some Codable & Sendable).Type, for key: StorageKey) throws {
        defaults.removeObject(forKey: key.key)
    }
}
