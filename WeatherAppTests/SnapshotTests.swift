//
//  SnapshotTests.swift
//  WeatherAppTests
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SnapshotTesting
import SwiftUI
import XCTest
@testable import WeatherApp

// MARK: - Snapshot Tests

@MainActor
final class SnapshotTests: XCTestCase {
    /// Set to true to record new snapshots, false to verify against existing ones
    private let isRecording = false

    // MARK: - WeatherCard Snapshots

    func testWeatherCardSnapshot() {
        let card = WeatherCard(
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

        let controller = UIHostingController(rootView: card)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    func testWeatherCardSunnySnapshot() {
        let card = WeatherCard(
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

        let controller = UIHostingController(rootView: card)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    func testWeatherCardRainySnapshot() {
        let card = WeatherCard(
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

        let controller = UIHostingController(rootView: card)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    // MARK: - CityRowView Snapshots

    func testCityRowSnapshot() {
        let row = CityRowView(cityName: "LONDON, UK") { }
            .frame(width: 350)
            .padding()
            .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: row)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 100)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    func testCityRowLongNameSnapshot() {
        let row = CityRowView(cityName: "SAN FRANCISCO, CALIFORNIA, USA") { }
            .frame(width: 350)
            .padding()
            .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: row)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 100)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    // MARK: - ScreenHeader Snapshots

    func testScreenHeaderWithAddButtonSnapshot() {
        let header = ScreenHeader(
            title: "CITIES",
            trailingButton: .add { }
        )
        .frame(width: 350)
        .padding()
        .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: header)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 150)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    func testScreenHeaderWithBackButtonSnapshot() {
        let header = ScreenHeader(
            title: "PARIS",
            subtitle: "HISTORICAL",
            leadingButton: .back { }
        )
        .frame(width: 350)
        .padding()
        .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: header)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 150)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    // MARK: - Empty State Snapshots

    func testCitiesListEmptyStateSnapshot() {
        let emptyState = VStack(spacing: AppTheme.Spacing.md) {
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
        .frame(width: 350, height: 300)
        .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: emptyState)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 350)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    func testNoWeatherHistoryEmptyStateSnapshot() {
        let emptyState = VStack(spacing: AppTheme.Spacing.md) {
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
        .frame(width: 350, height: 300)
        .padding(.horizontal)
        .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: emptyState)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 350)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    // MARK: - HistoryRowView Snapshots

    func testHistoryRowSnapshot() {
        let row = HistoryRowView(
            date: "15.12.2025 - 14:30",
            description: "Cloudy",
            temperature: "18.5°C"
        )
        .frame(width: 350)
        .padding()
        .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: row)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 120)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    // MARK: - Dark/Light Mode Snapshots

    func testWeatherCardDarkModeSnapshot() {
        let card = WeatherCard(
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

        let controller = UIHostingController(rootView: card)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        controller.overrideUserInterfaceStyle = .dark

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    // MARK: - PrimaryButton Snapshots

    func testPrimaryButtonSnapshot() {
        let button = PrimaryButton(icon: "plus") { }
            .padding()
            .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: button)
        controller.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    // MARK: - Navigation Button Snapshots

    func testNavigationButtonCloseSnapshot() {
        let button = NavigationButton(style: .close) { }
            .padding()
            .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: button)
        controller.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }

    func testNavigationButtonBackSnapshot() {
        let button = NavigationButton(style: .back) { }
            .padding()
            .background(AppTheme.Colors.background)

        let controller = UIHostingController(rootView: button)
        controller.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        assertSnapshot(of: controller, as: .image(on: .iPhone13Pro), record: isRecording)
    }
}
