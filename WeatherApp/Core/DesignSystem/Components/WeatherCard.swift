//
//  WeatherCard.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - WeatherCard

struct WeatherCard: View {
    let iconName: String
    let description: String
    let temperature: String
    let humidity: String
    let windSpeed: String

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Weather Icon
            Image(systemName: iconName)
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.Colors.accent)
                .padding(.top, AppTheme.Spacing.lg)

            // Weather Details
            VStack(spacing: AppTheme.Spacing.sm) {
                WeatherDetailRow(label: "DESCRIPTION", value: description)
                WeatherDetailRow(label: "TEMPERATURE", value: temperature)
                WeatherDetailRow(label: "HUMIDITY", value: humidity)
                WeatherDetailRow(label: "WINDSPEED", value: windSpeed)
            }
            .padding(.bottom, AppTheme.Spacing.lg)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.extraLarge))
    }
}

// MARK: - WeatherDetailRow

struct WeatherDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.secondaryText)
                .tracking(1.5)

            Spacer()

            Text(value)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.accent)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        WeatherCard(
            iconName: "cloud.sun.fill",
            description: "Cloudy",
            temperature: "20° C",
            humidity: "45%",
            windSpeed: "20 km/h"
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
