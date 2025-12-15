//
//  LocalizationService.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import SwiftMoLogger

// MARK: - LocalizationServiceProtocol

public protocol LocalizationServiceProtocol: Sendable {
    var isRTL: Bool { get }
    var currentLanguage: Language { get }
    var locale: Locale { get }
    var numbersLocale: Locale { get }
}

// MARK: - LocalizationService

public struct LocalizationService: LocalizationServiceProtocol {
    public init() { }

    public var isRTL: Bool {
        currentLanguage == .arabic
    }

    public let currentLanguage: Language = {
        guard let preferredAppLanguage = Locale.preferredLanguages.first else {
            assertionFailure("Couldn't find a preferred language for the user")
            SwiftMoLogger.error("Couldn't find a preferred language for the user", tag: .configuration)
            return .english
        }

        return .init(preferredAppLanguage)
    }()

    public var locale: Locale {
        currentLanguage.locale
    }

    public var numbersLocale: Locale {
        switch currentLanguage {
        case .english:
            locale
        case .arabic:
            Locale(identifier: "ar_EG")
        }
    }
}

// MARK: - Language

public enum Language: String, CaseIterable, Sendable {
    case english = "en"
    case arabic = "ar"

    public init(_ language: String) {
        if language.hasPrefix("ar") {
            self = .arabic
        } else if language.hasPrefix("en") {
            self = .english
        } else {
            SwiftMoLogger.warn(
                "Couldn't map user preferred language as the value is not supported: \(language)",
                tag: .configuration
            )
            self = .english
        }
    }

    public init(locale: Locale) {
        self = .init(locale.language.languageCode?.identifier ?? "en-US")
    }

    public var localizedName: String {
        switch self {
        case .english:
            "English"
        case .arabic:
            "عربي"
        }
    }

    public var name: String {
        switch self {
        case .english:
            "English"
        case .arabic:
            "Arabic"
        }
    }

    public var locale: Locale { .init(identifier: identifier) }

    public var identifier: String {
        switch self {
        case .english:
            "en-EG"
        case .arabic:
            "ar-EG"
        }
    }

    public var isRTL: Bool {
        self == .arabic
    }
}
