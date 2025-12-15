//
//  PrimaryButton.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - PrimaryButton

struct PrimaryButton: View {
    let icon: String
    let action: () -> Void

    init(icon: String, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(AppTheme.Colors.accent)
                .clipShape(
                    .rect(
                        topLeadingRadius: AppTheme.CornerRadius.large,
                        bottomLeadingRadius: AppTheme.CornerRadius.large,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0
                    )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - NavigationButton

struct NavigationButton: View {
    enum Style {
        case back
        case close
    }

    let style: Style
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(AppTheme.Colors.accent)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: AppTheme.CornerRadius.large,
                        topTrailingRadius: AppTheme.CornerRadius.large
                    )
                )
        }
        .buttonStyle(.plain)
    }

    private var iconName: String {
        switch style {
        case .back:
            "arrow.left"
        case .close:
            "xmark"
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        HStack {
            NavigationButton(style: .back) { }
            Spacer()
            PrimaryButton(icon: "plus") { }
        }

        HStack {
            NavigationButton(style: .close) { }
            Spacer()
        }
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
