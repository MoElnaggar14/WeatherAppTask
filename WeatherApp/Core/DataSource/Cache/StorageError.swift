//
//  StorageError.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

enum StorageError: Error {
    case notFound
    case cantWrite(Error)
    case cantDelete(StorageKey)
    case saveFailed(Error)
    case decodingFailed(Error)
    case encodingFailed(Error)
    case expired
    case invalidData
}
