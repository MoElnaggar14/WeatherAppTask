//
//  ComponentSnapshotTests.swift
//  WeatherAppTests
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SnapshotTesting
import SwiftUI
import XCTest
@testable import WeatherApp

// MARK: - Component Snapshot Tests

@MainActor
final class ComponentSnapshotTests: XCTestCase {
    // MARK: - WeatherCard

    func testWeatherCard() {
        let view = WeatherCard(
            iconURL: nil,
            iconName: "cloud.sun.fill",
            description: "Partly Cloudy",
            temperature: "22° C",
            humidity: "65%",
            windSpeed: "15 km/h"
        )
        .frame(width: 350)
        .padding()
        .background(Color.black)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testWeatherCardSunny() {
        let view = WeatherCard(
            iconURL: nil,
            iconName: "sun.max.fill",
            description: "Sunny",
            temperature: "30° C",
            humidity: "40%",
            windSpeed: "5 km/h"
        )
        .frame(width: 350)
        .padding()
        .background(Color.black)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testWeatherCardRainy() {
        let view = WeatherCard(
            iconURL: nil,
            iconName: "cloud.rain.fill",
            description: "Rainy",
            temperature: "15° C",
            humidity: "85%",
            windSpeed: "25 km/h"
        )
        .frame(width: 350)
        .padding()
        .background(Color.black)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - CityRowView

    func testCityRowView() {
        let view = CityRowView(cityName: "LONDON, UK") { }
            .frame(width: 350)
            .padding()
            .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testCityRowViewLongName() {
        let view = CityRowView(cityName: "SAN FRANCISCO, CALIFORNIA, USA") { }
            .frame(width: 350)
            .padding()
            .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - ScreenHeader

    func testScreenHeaderWithAddButton() {
        let view = ScreenHeader(
            title: "CITIES",
            trailingButton: .add { }
        )
        .frame(width: 350)
        .padding()
        .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testScreenHeaderWithBackButton() {
        let view = ScreenHeader(
            title: "PARIS",
            subtitle: "HISTORICAL",
            leadingButton: .back { }
        )
        .frame(width: 350)
        .padding()
        .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testScreenHeaderWithCloseButton() {
        let view = ScreenHeader(
            title: "LONDON UK",
            leadingButton: .close { }
        )
        .frame(width: 350)
        .padding()
        .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - HistoryRowView

    func testHistoryRowView() {
        let view = HistoryRowView(
            date: "15.12.2025 - 14:30",
            description: "Cloudy",
            temperature: "18.5°C"
        )
        .frame(width: 350)
        .padding()
        .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - Buttons

    func testPrimaryButton() {
        let view = PrimaryButton(icon: "plus") { }
            .padding()
            .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testNavigationButtonClose() {
        let view = NavigationButton(style: .close) { }
            .padding()
            .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testNavigationButtonBack() {
        let view = NavigationButton(style: .back) { }
            .padding()
            .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    // MARK: - Empty States

    func testCitiesEmptyState() {
        let view = VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "map")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(L10n.noCitiesAddedYet)
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Text(L10n.tapToAddYourFirstCity)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }

    func testNoWeatherHistoryEmptyState() {
        let view = VStack(spacing: AppTheme.Spacing.md) {
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(AppTheme.Colors.background)

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13Pro)))
    }
}
