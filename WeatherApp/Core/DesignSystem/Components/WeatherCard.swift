//
//  WeatherCard.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - WeatherCard

struct WeatherCard: View {
    let iconURL: URL?
    let iconName: String
    let description: String
    let temperature: String
    let humidity: String
    let windSpeed: String

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Weather Icon
            WeatherIconView(iconURL: iconURL, fallbackIconName: iconName)
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

// MARK: - WeatherIconView

struct WeatherIconView: View {
    let iconURL: URL?
    let fallbackIconName: String

    var body: some View {
        Group {
            if let url = iconURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 64, height: 64)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    case .failure:
                        fallbackIcon
                    @unknown default:
                        fallbackIcon
                    }
                }
            } else {
                fallbackIcon
            }
        }
    }

    private var fallbackIcon: some View {
        Image(systemName: fallbackIconName)
            .font(.system(size: 64))
            .foregroundStyle(AppTheme.Colors.accent)
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

#Preview("With URL Icon") {
    ZStack {
        Color.black.ignoresSafeArea()

        WeatherCard(
            iconURL: URL(string: "https://openweathermap.org/img/w/02d.png"),
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

#Preview("With Fallback Icon") {
    ZStack {
        Color.black.ignoresSafeArea()

        WeatherCard(
            iconURL: nil,
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
