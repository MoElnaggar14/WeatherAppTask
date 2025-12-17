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

    init(city: City, isPreview: Bool = false) {
        _viewModel = State(initialValue: WeatherDetailViewModel(city: city, isPreview: isPreview))
    }

    var body: some View {
        ZStack {
            WaveBackground()

            VStack(spacing: 0) {
                headerCard

                Spacer()

                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.appError {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.retry()
                        }
                    }
                } else if let weather = viewModel.latestWeather {
                    weatherContent(weather)
                } else {
                    noWeatherView
                }

                Spacer()

                if let weather = viewModel.latestWeather, viewModel.appError == nil {
                    footerView(for: weather)
                }
            }
        }
        .task {
            await viewModel.fetchWeather()
        }
    }

    private var loadingView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ProgressView()
                .tint(AppTheme.Colors.accent)
                .scaleEffect(1.5)

            Text(L10n.loadingWeather)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText)
        }
    }

    private func weatherContent(_ weather: Weather) -> some View {
        WeatherCard(
            iconURL: weather.iconURL,
            iconName: weatherIconName(for: weather.iconCode),
            description: weather.description.capitalized,
            temperature: "\(Int(weather.temperature))° C",
            humidity: weather.formattedHumidity,
            windSpeed: "-- km/h"
        )
        .padding(.horizontal, AppTheme.Spacing.lg)
        .transition(.scale.combined(with: .opacity))
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

            Text(L10n.pullToRefreshWeather)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))

            Button {
                Task {
                    await viewModel.fetchWeather()
                }
            } label: {
                HStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "arrow.clockwise")
                    Text(L10n.refresh)
                }
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.background)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.accent)
                .clipShape(Capsule())
            }
            .padding(.top, AppTheme.Spacing.sm)
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

#Preview("With Weather") {
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
        ),
        isPreview: true
    )
    .preferredColorScheme(.dark)
}

#Preview("No Weather") {
    WeatherDetailView(
        city: City(name: "New York", weatherHistory: []),
        isPreview: true
    )
    .preferredColorScheme(.dark)
}
