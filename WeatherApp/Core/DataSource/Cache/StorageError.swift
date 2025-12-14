//
//  StorageError.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

public enum StorageError: Error {
    case notFound
    case cantWrite(Error)
    case cantDelete(StorageKey)
}
