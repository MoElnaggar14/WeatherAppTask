//
//  AppError.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - AppError

enum AppError: LocalizedError, Equatable {
    case networkError(message: String)
    case cityNotFound
    case noInternetConnection
    case serverError
    case invalidData
    case deleteFailed
    case saveFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            message
        case .cityNotFound:
            "City not found. Please check the city name and try again."
        case .noInternetConnection:
            "No internet connection. Please check your network settings."
        case .serverError:
            "Server is temporarily unavailable. Please try again later."
        case .invalidData:
            "Unable to process the data. Please try again."
        case .deleteFailed:
            "Failed to delete. Please try again."
        case .saveFailed:
            "Failed to save. Please try again."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            "Check your internet connection and try again."
        case .cityNotFound:
            "Try searching for a different city or check the spelling."
        case .noInternetConnection:
            "Make sure you're connected to WiFi or mobile data."
        case .serverError:
            "Wait a few moments and try again."
        case .invalidData,
             .deleteFailed,
             .saveFailed:
            "Try again or restart the app."
        case .unknown:
            "Try again or contact support if the problem persists."
        }
    }

    var iconName: String {
        switch self {
        case .networkError,
             .noInternetConnection:
            "wifi.slash"
        case .cityNotFound:
            "magnifyingglass"
        case .serverError:
            "server.rack"
        case .invalidData:
            "exclamationmark.triangle"
        case .deleteFailed,
             .saveFailed:
            "xmark.circle"
        case .unknown:
            "questionmark.circle"
        }
    }

    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }

        if let horizonError = error as? HorizonError {
            if
                horizonError.text.lowercased().contains("network") ||
                horizonError.text.lowercased().contains("connection")
            {
                return .noInternetConnection
            }
            if
                horizonError.text.lowercased().contains("not found") ||
                horizonError.text.lowercased().contains("404")
            {
                return .cityNotFound
            }
            return .networkError(message: horizonError.text)
        }

        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost:
                return .noInternetConnection
            case NSURLErrorTimedOut:
                return .serverError
            default:
                return .networkError(message: error.localizedDescription)
            }
        }

        return .unknown
    }
}
