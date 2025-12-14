//
//  CacheProtocol.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - ReadableStorage

public protocol ReadableStorage {
    func fetchValue<T: Codable>(for key: StorageKey) async throws -> T?
}

// MARK: - WritableStorage

public protocol WritableStorage {
    func save(value: some Codable, for key: StorageKey) async throws
    func remove(type: (some Codable).Type, for key: StorageKey) async throws
}

public typealias Storage = ReadableStorage & WritableStorage
