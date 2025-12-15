//
//  LayoutDirection.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import SwiftUI

// MARK: - LayoutDirectionKey

/// Environment key for tracking the current layout direction
public struct LayoutDirectionKey: EnvironmentKey {
    public static let defaultValue: LayoutDirection = .leftToRight
}

public extension EnvironmentValues {
    var contentLayoutDirection: LayoutDirection {
        get { self[LayoutDirectionKey.self] }
        set { self[LayoutDirectionKey.self] = newValue }
    }
}

// MARK: - LanguageLayoutDirectionView

private struct LanguageLayoutDirectionView<ContentView: View>: View {
    let content: ContentView

    var body: some View {
        content
            .environment(\.layoutDirection, LocalizationService().isRTL ? .rightToLeft : .leftToRight)
    }
}

public extension View {
    func layoutDirectionForLanguage() -> some View {
        LanguageLayoutDirectionView(content: self)
    }
}
