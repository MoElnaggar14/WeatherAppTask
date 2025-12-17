//
//  ScreenHeader.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - ScreenHeader

struct ScreenHeader: View {
    let title: String
    let subtitle: String?
    let leadingButton: LeadingButton?
    let trailingButton: TrailingButton?

    enum LeadingButton {
        case back(() -> Void)
        case close(() -> Void)
        case settings(() -> Void)
    }

    enum TrailingButton {
        case add(() -> Void)
    }

    init(
        title: String,
        subtitle: String? = nil,
        leadingButton: LeadingButton? = nil,
        trailingButton: TrailingButton? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingButton = leadingButton
        self.trailingButton = trailingButton
    }

    var body: some View {
        HStack(alignment: .center) {
            // Leading button
            if let leadingButton {
                leadingButtonView(leadingButton)
            } else {
                Spacer()
                    .frame(width: 56)
            }

            Spacer()

            // Title
            VStack(spacing: 2) {
                Text(title)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
                    .tracking(2)

                if let subtitle {
                    Text(subtitle)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                        .tracking(2)
                }
            }

            Spacer()

            // Trailing button
            if let trailingButton {
                trailingButtonView(trailingButton)
            } else {
                Spacer()
                    .frame(width: 56)
            }
        }
    }

    @ViewBuilder
    private func leadingButtonView(_ button: LeadingButton) -> some View {
        switch button {
        case .back(let action):
            NavigationButton(style: .back, action: action)
        case .close(let action):
            NavigationButton(style: .close, action: action)
        case .settings(let action):
            NavigationButton(style: .settings, action: action)
        }
    }

    @ViewBuilder
    private func trailingButtonView(_ button: TrailingButton) -> some View {
        switch button {
        case .add(let action):
            PrimaryButton(icon: "plus", action: action)
        }
    }
}

// MARK: - Preview

#Preview("Cities Header") {
    ScreenHeader(
        title: "CITIES",
        trailingButton: .add { }
    )
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("Historical Header") {
    ScreenHeader(
        title: "LONDON",
        subtitle: "HISTORICAL",
        leadingButton: .back { }
    )
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("Detail Header") {
    ScreenHeader(
        title: "LONDON UK",
        leadingButton: .close { }
    )
    .background(Color.black)
    .preferredColorScheme(.dark)
}
