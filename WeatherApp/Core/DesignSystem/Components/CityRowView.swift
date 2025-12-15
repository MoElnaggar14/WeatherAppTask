//
//  CityRowView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - CityRowView

struct CityRowView: View {
    let cityName: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(cityName)
                    .font(AppTheme.Typography.cityName)
                    .foregroundStyle(AppTheme.Colors.primaryText)
                    .tracking(1)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.accent)
            }
            .padding(.vertical, AppTheme.Spacing.md)
            .padding(.horizontal, AppTheme.Spacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - HistoryRowView

struct HistoryRowView: View {
    let date: String
    let description: String
    let temperature: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(date)
                .font(AppTheme.Typography.footnote)
                .foregroundStyle(AppTheme.Colors.secondaryText)
                .tracking(1)

            Text("\(description), \(temperature)")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.accent)
        }
        .padding(.vertical, AppTheme.Spacing.md)
        .padding(.horizontal, AppTheme.Spacing.md)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        CityRowView(cityName: "London, UK") { }
        Divider()
        CityRowView(cityName: "Paris, FR") { }
        Divider()
        CityRowView(cityName: "Vienna, AUT") { }
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("History Row") {
    VStack(spacing: 0) {
        HistoryRowView(
            date: "01.10.2019 - 16:58",
            description: "Cloudy",
            temperature: "14°C"
        )
        Divider()
        HistoryRowView(
            date: "22.09.2019 - 10:31",
            description: "Rainy",
            temperature: "9°C"
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
