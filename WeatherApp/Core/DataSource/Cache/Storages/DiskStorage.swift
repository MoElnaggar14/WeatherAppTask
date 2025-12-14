//
//  DiskStorage.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - DiskStorage

final class DiskStorage {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let queue = DispatchQueue(label: "com.weatherapp.diskcache", attributes: .concurrent)

    init(subdirectory: String = "DiskCache") throws {
        let cachesDirectory = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        cacheDirectory = cachesDirectory.appendingPathComponent(subdirectory, isDirectory: true)

        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.createDirectory(
                at: cacheDirectory,
                withIntermediateDirectories: true
            )
        }
    }
}

// MARK: WritableStorage

extension DiskStorage: WritableStorage {
    func save(value: some Codable, for key: StorageKey) async throws {
        let fileURL = cacheDirectory.appendingPathComponent(key.key)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.async(flags: .barrier) {
                do {
                    try value.write(to: fileURL, options: .atomic)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: StorageError.saveFailed)
                }
            }
        }
    }

    func remove(type _: (some Codable).Type, for key: StorageKey) async throws {
        let fileURL = cacheDirectory.appendingPathComponent(key.key)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.async(flags: .barrier) {
                do {
                    if self.fileManager.fileExists(atPath: fileURL.path) {
                        try self.fileManager.removeItem(at: fileURL)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: ReadableStorage

extension DiskStorage: ReadableStorage {
    func fetchValue<T: Codable>(for key: StorageKey) async throws -> T? { }
}
