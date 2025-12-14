//
//  HorizonError.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

// MARK: - HorizonError

struct HorizonError: Error, Codable {
    var text: String
    var loggable: Bool = true
    var presentable: Bool = true

    init(text: String, loggable: Bool = true, presentable: Bool = true) {
        self.text = text
        self.loggable = loggable
        self.presentable = presentable
    }
}

extension String {
    func asHorizonError() -> HorizonError {
        .init(text: self)
    }
}

@MainActor
extension HorizonError {
    static var silentError: HorizonError {
        .init(text: "", loggable: false, presentable: false)
    }

    static var silentLoggableError: HorizonError {
        .init(text: "", loggable: true, presentable: false)
    }

    static var somethingWentWrong: HorizonError {
        "Oops, something went wrong".asHorizonError()
    }

    static var requestFailed: HorizonError {
        "requestFailed".asHorizonError()
    }

    static var inValidResponse: HorizonError {
        "inValidResponse".asHorizonError()
    }

    static var invalidURL: HorizonError {
        "invalidURL".asHorizonError()
    }

    static var requestCancelled: HorizonError {
        .silentError
    }

    // TODO: - [Future] Localize -
    static var refreshTokenExpired: HorizonError {
        "You must log in again...".asHorizonError()
    }

    // TODO: - [Future] Localize -
    static var noNetworkOrTooWeak: HorizonError {
        "We can't detect a network, either because it's too weak or it's non-existent, most probably the signal?".asHorizonError()
    }

    static var tokenExpired: HorizonError {
        .silentLoggableError
    }

    static var noPermission: HorizonError {
        "Sorry but this feature is unavailable without a permission 🙁".asHorizonError()
    }
}
