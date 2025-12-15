//
//  CacheProtocol.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - CacheManagerProtocol

protocol CacheManagerProtocol: Sendable {
    func fetch<T: Codable & Sendable>(for key: StorageKey) async throws -> T?
    func save(value: some Codable & Sendable, for key: StorageKey) async throws
    func remove(type: (some Codable & Sendable).Type, for key: StorageKey) async throws
}
