//
//  CitiesListView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - CitiesListView

struct CitiesListView: View {
    @State private var viewModel = CitiesViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                WaveBackground()

                VStack(spacing: 0) {
                    ScreenHeader(
                        title: L10n.citiesTitle.uppercased(),
                        trailingButton: .add {
                            viewModel.showAddCity = true
                        }
                    )
                    .padding(.top, AppTheme.Spacing.md)

                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .tint(AppTheme.Colors.accent)
                        Spacer()
                    } else if viewModel.cities.isEmpty {
                        emptyStateView
                    } else {
                        citiesListView
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: City.self) { city in
                HistoricalWeatherView(city: city)
            }
        }
        .sheet(isPresented: $viewModel.showAddCity) {
            AddCityView { _ in
                viewModel.showAddCity = false
                Task {
                    await viewModel.loadCities()
                }
            }
        }
        .sheet(isPresented: $viewModel.showWeatherDetail) {
            if let city = viewModel.selectedCity {
                WeatherDetailView(city: city)
            }
        }
        .task {
            await viewModel.loadCities()
        }
    }

    private var citiesListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.cities) { city in
                    VStack(spacing: 0) {
                        CityRowView(cityName: city.name.uppercased()) {
                            navigationPath.append(city)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteCity(city)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                viewModel.showWeatherDetailForCity(city)
                            } label: {
                                Label("View Weather", systemImage: "cloud.sun")
                            }
                        }

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

            Image(systemName: "map")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text("No cities added yet")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text("Tap + to add your first city")
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    CitiesListView()
        .preferredColorScheme(.dark)
}
