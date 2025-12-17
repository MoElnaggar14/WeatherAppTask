//
//  AddCityView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - AddCityView

struct AddCityView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddCityViewModel()

    let onCityAdded: (City) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // Prompt text
                    Text(L10n.enterCityPostcodeOrAirportLocation)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundStyle(.primary)
                        .padding(.top, AppTheme.Spacing.md)
                        .padding(.bottom, AppTheme.Spacing.sm)

                    // Search results
                    if viewModel.isSearching {
                        Spacer()
                        VStack(spacing: AppTheme.Spacing.sm) {
                            ProgressView()
                            Text(L10n.searching)
                                .font(AppTheme.Typography.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    } else if !viewModel.searchResults.isEmpty {
                        searchResultsList
                    } else if viewModel.hasSearched {
                        noResultsView
                    } else {
                        hintView
                    }
                }

                // Loading overlay when adding city
                if viewModel.isAddingCity {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    VStack(spacing: AppTheme.Spacing.md) {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.2)
                        Text(L10n.addingCity)
                            .font(AppTheme.Typography.subheadline)
                            .foregroundStyle(.white)
                    }
                    .padding(AppTheme.Spacing.lg)
                    .background(Color.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
                }
            }
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: L10n.search
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) {
                        dismiss()
                    }
                    .disabled(viewModel.isAddingCity)
                }
            }
        }
        .toast(isPresented: $viewModel.showErrorToast, message: viewModel.errorMessage, isError: true)
        .onChange(of: viewModel.searchQuery) { _, newValue in
            Task {
                await viewModel.search(query: newValue)
            }
        }
        .interactiveDismissDisabled(viewModel.isAddingCity)
    }

    private var searchResultsList: some View {
        List(viewModel.searchResults) { result in
            Button {
                Task {
                    if let city = await viewModel.addCity(from: result) {
                        onCityAdded(city)
                        dismiss()
                    }
                }
            } label: {
                CitySearchResultRow(result: result)
            }
            .disabled(viewModel.isAddingCity)
        }
        .listStyle(.plain)
    }

    private var noResultsView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(L10n.noResultsFound)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.secondary)

            Text(L10n.tryADifferentSearchTerm)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
    }

    private var hintView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Spacer()

            Image(systemName: "globe.americas.fill")
                .font(.system(size: 56))
                .foregroundStyle(.secondary.opacity(0.5))

            VStack(spacing: AppTheme.Spacing.xs) {
                Text("Search for a city")
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(.secondary)

                Text("Enter at least 2 characters to search")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
    }
}

// MARK: - CitySearchResultRow

private struct CitySearchResultRow: View {
    let result: CitySearchResult

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(AppTheme.Colors.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text(result.name)
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(.primary)

                HStack(spacing: AppTheme.Spacing.xxs) {
                    if let state = result.state, !state.isEmpty {
                        Text(state)
                            .font(AppTheme.Typography.subheadline)
                            .foregroundStyle(.secondary)

                        Text("•")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundStyle(.tertiary)
                    }

                    Text(countryName(for: result.country))
                        .font(AppTheme.Typography.subheadline)
                        .foregroundStyle(.secondary)

                    Text(countryFlag(for: result.country))
                        .font(AppTheme.Typography.subheadline)
                }
            }

            Spacer()

            Image(systemName: "plus.circle.fill")
                .font(.system(size: 22))
                .foregroundStyle(AppTheme.Colors.accent)
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }

    private func countryName(for code: String) -> String {
        Locale.current.localizedString(forRegionCode: code) ?? code
    }

    private func countryFlag(for code: String) -> String {
        code
            .uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127_397 + $0.value) }
            .map { String($0) }
            .joined()
    }
}

// MARK: - Preview

#Preview {
    AddCityView { _ in }
}
