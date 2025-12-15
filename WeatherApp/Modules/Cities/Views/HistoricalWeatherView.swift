//
//  HistoricalWeatherView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - HistoricalWeatherView

struct HistoricalWeatherView: View {
    @Environment(\.dismiss) private var dismiss

    let city: City

    var body: some View {
        ZStack {
            WaveBackground()

            VStack(spacing: 0) {
                ScreenHeader(
                    title: city.name.uppercased(),
                    subtitle: "HISTORICAL",
                    leadingButton: .back {
                        dismiss()
                    }
                )
                .padding(.top, AppTheme.Spacing.md)

                if city.weatherHistory.isEmpty {
                    emptyStateView
                } else {
                    historyListView
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var historyListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(city.sortedWeatherHistory) { weather in
                    VStack(spacing: 0) {
                        HistoryRowView(
                            date: formatDate(weather.requestDate),
                            description: weather.description.capitalized,
                            temperature: weather.formattedTemperature
                        )

                        Divider()
                            .background(AppTheme.Colors.separator)
                            .padding(.horizontal, AppTheme.Spacing.md)
                    }
                }
            }
            .padding(.top, AppTheme.Spacing.lg)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Spacer()

            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(L10n.noWeatherHistory)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(L10n.weatherDataWillAppearHereAfterFetching)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    HistoricalWeatherView(
        city: City(
            name: "London, UK",
            weatherHistory: [
                Weather(
                    description: "Cloudy",
                    temperature: 14,
                    humidity: 65,
                    iconCode: "04d",
                    requestDate: Date()
                ),
                Weather(
                    description: "Rainy",
                    temperature: 9,
                    humidity: 85,
                    iconCode: "10d",
                    requestDate: Date().addingTimeInterval(-86400)
                ),
                Weather(
                    description: "Sunny",
                    temperature: 22,
                    humidity: 45,
                    iconCode: "01d",
                    requestDate: Date().addingTimeInterval(-172_800)
                ),
            ]
        )
    )
    .preferredColorScheme(.dark)
}
