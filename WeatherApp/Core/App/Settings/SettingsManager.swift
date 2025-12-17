//
//  SettingsManager.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - AppThemeMode

enum AppThemeMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: L10n.systemDefault
        case .light: L10n.lightMode
        case .dark: L10n.darkMode
        }
    }

    var iconName: String {
        switch self {
        case .system: "circle.lefthalf.filled"
        case .light: "sun.max.fill"
        case .dark: "moon.fill"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

// MARK: - AppLanguage

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case english = "en"
    case arabic = "ar"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: L10n.systemDefault
        case .english: "English"
        case .arabic: "العربية"
        }
    }

    var flagEmoji: String {
        switch self {
        case .system: "🌐"
        case .english: "🇺🇸"
        case .arabic: "🇸🇦"
        }
    }
}

// MARK: - SettingsManager

@MainActor
@Observable
final class SettingsManager {
    static let shared = SettingsManager()

    var themeMode: AppThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: Keys.themeMode)
        }
    }

    var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Keys.language)
            applyLanguage()
        }
    }

    private enum Keys {
        static let themeMode = "app_theme_mode"
        static let language = "app_language"
    }

    private init() {
        // Load saved theme
        if
            let savedTheme = UserDefaults.standard.string(forKey: Keys.themeMode),
            let theme = AppThemeMode(rawValue: savedTheme)
        {
            themeMode = theme
        } else {
            themeMode = .system
        }

        // Load saved language
        if
            let savedLanguage = UserDefaults.standard.string(forKey: Keys.language),
            let language = AppLanguage(rawValue: savedLanguage)
        {
            self.language = language
        } else {
            language = .system
        }
    }

    private func applyLanguage() {
        guard language != .system else {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            return
        }

        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
    }
}
