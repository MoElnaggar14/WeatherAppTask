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
                    ProgressView()
                    Spacer()
                } else if !viewModel.searchResults.isEmpty {
                    searchResultsList
                } else if !viewModel.searchQuery.isEmpty, viewModel.searchResults.isEmpty {
                    noResultsView
                } else {
                    Spacer()
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
                }
            }
        }
        .onChange(of: viewModel.searchQuery) { _, newValue in
            Task {
                await viewModel.search(query: newValue)
            }
        }
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
                Text(result)
                    .foregroundStyle(.primary)
            }
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

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    AddCityView { _ in }
}
