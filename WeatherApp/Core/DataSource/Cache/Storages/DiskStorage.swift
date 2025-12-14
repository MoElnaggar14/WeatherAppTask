//
//  DiskStorage.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import SwiftMoLogger

// MARK: - DiskStorage

final class DiskStorage {
    private let fileManager = FileManager.default
    private let cachesDirectoryURL: URL?
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    init() {
        cachesDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    private func url(for key: StorageKey) -> URL? {
        cachesDirectoryURL?.appendingPathComponent(key.key)
    }
}

// MARK: ReadableStorage

extension DiskStorage: ReadableStorage {
    func fetch<T: Codable>(for key: StorageKey) async throws -> T? {
        guard let fileURL = url(for: key) else {
            throw StorageError.notFound
        }

        guard fileManager.fileExists(atPath: fileURL.path) else {
            // Return nil if not found, as per the protocol's nullable return type
            // or you could throw .notFound if you changed the protocol return type.
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            return try jsonDecoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw StorageError.decodingFailed(decodingError)
        } catch {
            throw StorageError.cantWrite(error)
        }
    }
}

// MARK: WritableStorage

extension DiskStorage: WritableStorage {
    func save(value: some Codable, for key: StorageKey) async throws {
        guard let fileURL = url(for: key) else {
            throw StorageError.notFound
        }

        let data: Data
        do {
            data = try jsonEncoder.encode(value)
        } catch {
            throw StorageError.encodingFailed(error)
        }

        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            throw StorageError.saveFailed(error)
        }
    }

    func remove(type: (some Codable).Type, for key: StorageKey) async throws {
        guard let fileURL = url(for: key) else {
            throw StorageError.notFound
        }

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return
        }

        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            throw StorageError.cantDelete(key)
        }
    }
}
