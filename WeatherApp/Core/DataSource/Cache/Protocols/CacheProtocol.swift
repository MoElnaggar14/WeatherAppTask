//
//  CacheProtocol.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - ReadableStorage

protocol ReadableStorage {
    func fetch<T: Codable>(for key: StorageKey) async throws -> T?
}

// MARK: - WritableStorage

protocol WritableStorage {
    func save(value: some Codable, for key: StorageKey) async throws
    func remove(type: (some Codable).Type, for key: StorageKey) async throws
}

typealias Storage = ReadableStorage & WritableStorage
