//
//  NetworkErrorToHorizonErrorAdapter.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - NetworkErrorToHorizonErrorAdapter

struct NetworkErrorToHorizonErrorAdapter: AdapterProtocol {
    typealias Input = Error
    typealias Output = HorizonError

    func adapt(_ error: Error) -> HorizonError {
        switch error {
        case URLError.unknown:
            .somethingWentWrong
        case URLError.cancelled:
            .requestCancelled
        case URLError.networkConnectionLost:
            .noNetworkOrTooWeak
        case URLError.notConnectedToInternet:
            .noNetworkOrTooWeak
        default:
            .somethingWentWrong
        }
    }
}

// MARK: - HTTP Status Code Extensions

public extension Int {
    var isInSuccessRange: Bool {
        (200 ..< 300).contains(self)
    }

    var isInClientErrorRange: Bool {
        (400 ..< 500).contains(self)
    }

    var isInServerErrorRange: Bool {
        (500 ..< 600).contains(self)
    }

    var isEmpty: Bool {
        self == 204 || self == 205
    }
}
