//
//  StorageKey.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

struct StorageKey: Sendable {
    let key: String
    let suitableStorage: CacheManager.SupportedStorage

    init(key: String, suitableStorage: CacheManager.SupportedStorage) {
        self.key = key
        self.suitableStorage = suitableStorage
    }
}
