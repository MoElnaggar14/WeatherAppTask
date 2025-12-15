//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - WeatherDetailView

struct WeatherDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: WeatherDetailViewModel

    init(city: City) {
        _viewModel = State(initialValue: WeatherDetailViewModel(city: city))
    }

    var body: some View {
        ZStack {
            WaveBackground()

            VStack(spacing: 0) {
                // Header card with title
                headerCard

                Spacer()

                // Weather card
                if let weather = viewModel.latestWeather {
                    WeatherCard(
                        iconURL: weather.iconURL,
                        iconName: weatherIconName(for: weather.iconCode),
                        description: weather.description.capitalized,
                        temperature: "\(Int(weather.temperature))° C",
                        humidity: weather.formattedHumidity,
                        windSpeed: "-- km/h"
                    )
                    .padding(.horizontal, AppTheme.Spacing.lg)
                } else if viewModel.isLoading {
                    ProgressView()
                        .tint(AppTheme.Colors.accent)
                } else {
                    noWeatherView
                }

                Spacer()

                // Footer
                if let weather = viewModel.latestWeather {
                    footerView(for: weather)
                }
            }
        }
        .task {
            await viewModel.fetchWeather()
        }
    }

    private var headerCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                NavigationButton(style: .close) {
                    dismiss()
                }

                Spacer()

                Text(viewModel.city.name.uppercased())
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
                    .tracking(2)
                    .padding(.top, AppTheme.Spacing.md)

                Spacer()

                // Placeholder for symmetry
                Color.clear
                    .frame(width: 56, height: 56)
            }
        }
        .padding(.top, AppTheme.Spacing.md)
        .padding(.trailing, AppTheme.Spacing.md)
        .background(
            AppTheme.Colors.cardBackground
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: AppTheme.CornerRadius.extraLarge,
                        bottomTrailingRadius: AppTheme.CornerRadius.extraLarge,
                        topTrailingRadius: 0
                    )
                )
        )
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    private var noWeatherView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "cloud.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(L10n.noWeatherData)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.secondaryText)
        }
    }

    private func footerView(for weather: Weather) -> some View {
        VStack(spacing: AppTheme.Spacing.xxs) {
            Text(L10n.weatherInformationForReceivedOn(viewModel.city.name.uppercased()))
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))
                .tracking(1)

            Text(formatDate(weather.requestDate))
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))
        }
        .padding(.bottom, AppTheme.Spacing.xl)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        return formatter.string(from: date)
    }

    private func weatherIconName(for code: String) -> String {
        switch code {
        case "01d",
             "01n":
            "sun.max.fill"
        case "02d",
             "02n":
            "cloud.sun.fill"
        case "03d",
             "03n",
             "04d",
             "04n":
            "cloud.fill"
        case "09d",
             "09n":
            "cloud.drizzle.fill"
        case "10d",
             "10n":
            "cloud.rain.fill"
        case "11d",
             "11n":
            "cloud.bolt.fill"
        case "13d",
             "13n":
            "snowflake"
        case "50d",
             "50n":
            "cloud.fog.fill"
        default:
            "cloud.fill"
        }
    }
}

// MARK: - Preview

#Preview {
    WeatherDetailView(
        city: City(
            name: "London UK",
            weatherHistory: [
                Weather(
                    description: "Cloudy",
                    temperature: 20,
                    humidity: 45,
                    iconCode: "02d",
                    requestDate: Date()
                ),
            ]
        )
    )
    .preferredColorScheme(.dark)
}
