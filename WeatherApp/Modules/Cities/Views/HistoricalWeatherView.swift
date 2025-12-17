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
    @State private var viewModel: HistoricalWeatherViewModel

    init(city: City, isPreview: Bool = false) {
        _viewModel = State(initialValue: HistoricalWeatherViewModel(city: city, isPreview: isPreview))
    }

    var body: some View {
        ZStack {
            WaveBackground()

            VStack(spacing: 0) {
                ScreenHeader(
                    title: viewModel.city.name.uppercased(),
                    subtitle: L10n.historical,
                    leadingButton: .back {
                        dismiss()
                    }
                )
                .padding(.top, AppTheme.Spacing.md)

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(AppTheme.Colors.accent)
                    Spacer()
                } else if let error = viewModel.error {
                    Spacer()
                    ErrorView(error: error) {
                        Task {
                            await viewModel.refreshCity()
                        }
                    }
                    Spacer()
                } else if viewModel.weatherHistory.isEmpty {
                    emptyStateView
                } else {
                    historyListView
                }
            }

            if viewModel.isDeleting {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .navigationBarHidden(true)
        .toast(isPresented: $viewModel.showSuccessToast, message: viewModel.successMessage)
        .confirmationDialog(
            L10n.deleteWeatherRecord,
            isPresented: $viewModel.showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(L10n.delete, role: .destructive) {
                Task {
                    await viewModel.deleteWeather()
                }
            }
            Button(L10n.cancel, role: .cancel) {
                viewModel.cancelDelete()
            }
        } message: {
            Text(L10n.deleteWeatherRecordConfirmation)
        }
        .task {
            await viewModel.refreshCity()
        }
        .sheet(isPresented: $viewModel.showWeatherDetail) {
            if let weather = viewModel.selectedWeather {
                WeatherHistoryDetailSheet(
                    weather: weather,
                    cityName: viewModel.city.name
                )
            }
        }
    }

    private var historyListView: some View {
        List {
            ForEach(viewModel.weatherHistory) { weather in
                Button {
                    viewModel.selectWeather(weather)
                } label: {
                    HistoryRowContent(
                        date: formatDate(weather.requestDate),
                        description: weather.description.capitalized,
                        temperature: weather.formattedTemperature
                    )
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.confirmDelete(weather)
                    } label: {
                        Label(L10n.delete, systemImage: "trash")
                    }
                }
                .contextMenu {
                    Button(role: .destructive) {
                        viewModel.confirmDelete(weather)
                    } label: {
                        Label(L10n.delete, systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.refreshCity()
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

// MARK: - WeatherHistoryDetailSheet

private struct WeatherHistoryDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let weather: Weather
    let cityName: String

    var body: some View {
        ZStack {
            WaveBackground()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppTheme.Colors.secondaryText)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.top, AppTheme.Spacing.md)

                Spacer()

                // Weather Card
                WeatherCard(
                    iconURL: weather.iconURL,
                    iconName: weatherIconName(for: weather.iconCode),
                    description: weather.description.capitalized,
                    temperature: "\(Int(weather.temperature))° C",
                    humidity: weather.formattedHumidity,
                    windSpeed: "-- km/h"
                )
                .padding(.horizontal, AppTheme.Spacing.lg)

                Spacer()

                // Footer
                VStack(spacing: AppTheme.Spacing.xxs) {
                    Text(L10n.weatherInformationForReceivedOn(cityName.uppercased()))
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))
                        .tracking(1)

                    Text(formatDate(weather.requestDate))
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))
                }
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        return formatter.string(from: date)
    }

    private func weatherIconName(for code: String) -> String {
        switch code {
        case "01d",
             "01n": "sun.max.fill"
        case "02d",
             "02n": "cloud.sun.fill"
        case "03d",
             "03n",
             "04d",
             "04n": "cloud.fill"
        case "09d",
             "09n": "cloud.drizzle.fill"
        case "10d",
             "10n": "cloud.rain.fill"
        case "11d",
             "11n": "cloud.bolt.fill"
        case "13d",
             "13n": "snowflake"
        case "50d",
             "50n": "cloud.fog.fill"
        default: "cloud.fill"
        }
    }
}

// MARK: - HistoryRowContent

private struct HistoryRowContent: View {
    let date: String
    let description: String
    let temperature: String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(date)
                        .font(AppTheme.Typography.footnote)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                        .tracking(1)

                    Text("\(description), \(temperature)")
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(AppTheme.Colors.accent)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.5))
            }
            .padding(.vertical, AppTheme.Spacing.md)
            .padding(.horizontal, AppTheme.Spacing.md)

            Divider()
                .background(AppTheme.Colors.separator)
                .padding(.horizontal, AppTheme.Spacing.md)
        }
    }
}

// MARK: - Preview

#Preview("With History") {
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
        ),
        isPreview: true
    )
    .preferredColorScheme(.dark)
}

#Preview("Empty") {
    HistoricalWeatherView(
        city: City(name: "New York, USA", weatherHistory: []),
        isPreview: true
    )
    .preferredColorScheme(.dark)
}
