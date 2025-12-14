//
//  DiskStorage.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - DiskStorage

actor DiskStorage {
    private let cachesDirectoryURL: URL?
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    init() {
        cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    private func url(for key: StorageKey) -> URL? {
        cachesDirectoryURL?.appendingPathComponent(key.key)
    }

    func fetch<T: Codable & Sendable>(for key: StorageKey) throws -> T? {
        guard let fileURL = url(for: key) else {
            throw StorageError.notFound
        }

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
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

    func save(value: some Codable & Sendable, for key: StorageKey) throws {
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

    func remove(type: (some Codable & Sendable).Type, for key: StorageKey) throws {
        guard let fileURL = url(for: key) else {
            throw StorageError.notFound
        }

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw StorageError.cantDelete(key)
        }
    }
}
