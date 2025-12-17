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
        List(viewModel.searchResults, id: \.self) { result in
            Button {
                Task {
                    if let city = await viewModel.addCity(name: result) {
                        onCityAdded(city)
                        dismiss()
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(AppTheme.Colors.accent)

                    Text(result)
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.Colors.accent)
                }
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

// MARK: - Preview

#Preview {
    AddCityView { _ in }
}
