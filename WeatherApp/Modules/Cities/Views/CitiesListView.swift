//
//  CitiesListView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - CitiesListView

struct CitiesListView: View {
    @State private var viewModel: CitiesViewModel
    @State private var navigationPath = NavigationPath()

    init(viewModel: CitiesViewModel = CitiesViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

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

                    if viewModel.isLoading, viewModel.cities.isEmpty {
                        Spacer()
                        ProgressView()
                            .tint(AppTheme.Colors.accent)
                        Spacer()
                    } else if let error = viewModel.appError, viewModel.cities.isEmpty {
                        Spacer()
                        ErrorView(error: error) {
                            Task {
                                await viewModel.loadCities()
                            }
                        }
                        Spacer()
                    } else if viewModel.cities.isEmpty {
                        emptyStateView
                    } else {
                        citiesListView
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
        .toast(isPresented: $viewModel.showSuccessToast, message: viewModel.successMessage)
        .toast(isPresented: $viewModel.showErrorToast, message: viewModel.errorMessage, isError: true)
        .confirmationDialog(
            L10n.deleteCity,
            isPresented: $viewModel.showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(L10n.delete, role: .destructive) {
                Task {
                    await viewModel.confirmDeleteCity()
                }
            }
            Button(L10n.cancel, role: .cancel) {
                viewModel.cancelDelete()
            }
        } message: {
            Text(L10n.deleteCityConfirmation)
        }
        .task {
            await viewModel.loadCities()
        }
    }

    private var citiesListView: some View {
        List {
            ForEach(viewModel.cities) { city in
                CityRowContent(cityName: city.name.uppercased()) {
                    navigationPath.append(city)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewModel.requestDeleteCity(city)
                    } label: {
                        Label(L10n.delete, systemImage: "trash")
                    }

                    Button {
                        viewModel.showWeatherDetailForCity(city)
                    } label: {
                        Label(L10n.viewWeather, systemImage: "cloud.sun")
                    }
                    .tint(AppTheme.Colors.accent)
                }
                .contextMenu {
                    Button(role: .destructive) {
                        viewModel.requestDeleteCity(city)
                    } label: {
                        Label(L10n.delete, systemImage: "trash")
                    }

                    Button {
                        viewModel.showWeatherDetailForCity(city)
                    } label: {
                        Label(L10n.viewWeather, systemImage: "cloud.sun")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.loadCities()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Spacer()

            Image(systemName: "map")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(L10n.noCitiesAddedYet)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(L10n.tapToAddYourFirstCity)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))

            Spacer()
        }
    }
}

// MARK: - CityRowContent

private struct CityRowContent: View {
    let cityName: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
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

                Divider()
                    .background(AppTheme.Colors.separator)
                    .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("With Cities") {
    CitiesListView(
        viewModel: CitiesViewModel(
            isPreview: true,
            mockCities: City.mockCities
        )
    )
    .preferredColorScheme(.dark)
}

#Preview("Empty State") {
    CitiesListView(
        viewModel: CitiesViewModel(isPreview: true, mockCities: [])
    )
    .preferredColorScheme(.dark)
}
