//
//  SnapshotTests.swift
//  WeatherAppTests
//
//  Created by Mohammed Elnaggar on 15/12/2025.

import SwiftUI
import Testing
import UIKit
@testable import WeatherApp

// MARK: - Snapshot

@MainActor
enum Snapshot {
    static func render(
        _ view: some View,
        size: CGSize,
        colorScheme: ColorScheme = .dark
    ) -> UIImage? {
        let wrappedView = view
            .frame(width: size.width, height: size.height)
            .environment(\.colorScheme, colorScheme)

        let renderer = ImageRenderer(content: wrappedView)
        renderer.scale = UIScreen.main.scale

        return renderer.uiImage
    }

    static func saveSnapshot(
        _ image: UIImage,
        named name: String,
        in directory: String = #filePath
    ) throws {
        let fileURL = URL(fileURLWithPath: directory)
            .deletingLastPathComponent()
            .appendingPathComponent("__Snapshots__")
            .appendingPathComponent("\(name).png")

        // Create directory if needed
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        guard let data = image.pngData() else {
            throw SnapshotError.failedToCreatePNGData
        }

        try data.write(to: fileURL)
    }

    static func loadSnapshot(
        named name: String,
        in directory: String = #filePath
    ) -> UIImage? {
        let fileURL = URL(fileURLWithPath: directory)
            .deletingLastPathComponent()
            .appendingPathComponent("__Snapshots__")
            .appendingPathComponent("\(name).png")

        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }

        return UIImage(data: data)
    }

    static func compare(
        _ image1: UIImage,
        _ image2: UIImage,
        tolerance: Double = 0.001
    ) -> Bool {
        guard
            let data1 = image1.pngData(),
            let data2 = image2.pngData()
        else {
            return false
        }

        // Simple byte comparison
        if data1 == data2 { return true }

        // If sizes don't match, images are different
        guard image1.size == image2.size else { return false }

        // For more complex comparison, check pixel differences
        return comparePixels(image1, image2, tolerance: tolerance)
    }

    private static func comparePixels(
        _ image1: UIImage,
        _ image2: UIImage,
        tolerance: Double
    ) -> Bool {
        guard
            let cgImage1 = image1.cgImage,
            let cgImage2 = image2.cgImage
        else {
            return false
        }

        let width = cgImage1.width
        let height = cgImage1.height

        guard width == cgImage2.width, height == cgImage2.height else {
            return false
        }

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let totalBytes = height * bytesPerRow

        var pixels1 = [UInt8](repeating: 0, count: totalBytes)
        var pixels2 = [UInt8](repeating: 0, count: totalBytes)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard
            let context1 = CGContext(
                data: &pixels1,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            ),
            let context2 = CGContext(
                data: &pixels2,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            )
        else {
            return false
        }

        context1.draw(cgImage1, in: CGRect(x: 0, y: 0, width: width, height: height))
        context2.draw(cgImage2, in: CGRect(x: 0, y: 0, width: width, height: height))

        var differentPixels = 0
        let totalPixels = width * height

        for i in stride(from: 0, to: totalBytes, by: bytesPerPixel) {
            let r1 = pixels1[i], g1 = pixels1[i + 1], b1 = pixels1[i + 2], a1 = pixels1[i + 3]
            let r2 = pixels2[i], g2 = pixels2[i + 1], b2 = pixels2[i + 2], a2 = pixels2[i + 3]

            if r1 != r2 || g1 != g2 || b1 != b2 || a1 != a2 {
                differentPixels += 1
            }
        }

        let differenceRatio = Double(differentPixels) / Double(totalPixels)
        return differenceRatio <= tolerance
    }

    enum SnapshotError: Error {
        case failedToCreatePNGData
        case failedToRenderView
        case snapshotMismatch
        case referenceNotFound
    }
}

// MARK: - SnapshotTests

@Suite("Snapshot Tests")
@MainActor
struct SnapshotTests {
    /// Set to true to record new snapshots
    private let isRecording = true

    // MARK: - WeatherCard Tests

    @Test("WeatherCard renders correctly")
    func weatherCardSnapshot() throws {
        let view = WeatherCard(
            iconURL: nil,
            iconName: "cloud.sun.fill",
            description: "Partly Cloudy",
            temperature: "22° C",
            humidity: "65%",
            windSpeed: "15 km/h"
        )
        .padding()
        .background(Color.black)

        let size = CGSize(width: 390, height: 400)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "WeatherCard")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "WeatherCard") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    @Test("WeatherCard sunny variant")
    func weatherCardSunnySnapshot() throws {
        let view = WeatherCard(
            iconURL: nil,
            iconName: "sun.max.fill",
            description: "Sunny",
            temperature: "30° C",
            humidity: "40%",
            windSpeed: "5 km/h"
        )
        .padding()
        .background(Color.black)

        let size = CGSize(width: 390, height: 400)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "WeatherCard_Sunny")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "WeatherCard_Sunny") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    @Test("WeatherCard rainy variant")
    func weatherCardRainySnapshot() throws {
        let view = WeatherCard(
            iconURL: nil,
            iconName: "cloud.rain.fill",
            description: "Rainy",
            temperature: "15° C",
            humidity: "85%",
            windSpeed: "25 km/h"
        )
        .padding()
        .background(Color.black)

        let size = CGSize(width: 390, height: 400)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "WeatherCard_Rainy")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "WeatherCard_Rainy") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    // MARK: - CityRowView Tests

    @Test("CityRowView renders correctly")
    func cityRowSnapshot() throws {
        let view = CityRowView(cityName: "LONDON, UK") { }
            .padding()
            .background(AppTheme.Colors.background)

        let size = CGSize(width: 390, height: 100)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "CityRowView")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "CityRowView") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    // MARK: - ScreenHeader Tests

    @Test("ScreenHeader with add button")
    func screenHeaderAddButtonSnapshot() throws {
        let view = ScreenHeader(
            title: "CITIES",
            trailingButton: .add { }
        )
        .padding()
        .background(AppTheme.Colors.background)

        let size = CGSize(width: 390, height: 150)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "ScreenHeader_AddButton")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "ScreenHeader_AddButton") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    @Test("ScreenHeader with back button and subtitle")
    func screenHeaderBackButtonSnapshot() throws {
        let view = ScreenHeader(
            title: "PARIS",
            subtitle: "HISTORICAL",
            leadingButton: .back { }
        )
        .padding()
        .background(AppTheme.Colors.background)

        let size = CGSize(width: 390, height: 150)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "ScreenHeader_BackButton")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "ScreenHeader_BackButton") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    // MARK: - Empty State Tests

    @Test("Cities empty state")
    func citiesEmptyStateSnapshot() throws {
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
        .padding()
        .background(AppTheme.Colors.background)

        let size = CGSize(width: 390, height: 300)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "CitiesEmptyState")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "CitiesEmptyState") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    // MARK: - HistoryRowView Tests

    @Test("HistoryRowView renders correctly")
    func historyRowSnapshot() throws {
        let view = HistoryRowView(
            date: "15.12.2025 - 14:30",
            description: "Cloudy",
            temperature: "18.5°C"
        )
        .padding()
        .background(AppTheme.Colors.background)

        let size = CGSize(width: 390, height: 120)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "HistoryRowView")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "HistoryRowView") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    // MARK: - Button Tests

    @Test("PrimaryButton renders correctly")
    func primaryButtonSnapshot() throws {
        let view = PrimaryButton(icon: "plus") { }
            .padding()
            .background(AppTheme.Colors.background)

        let size = CGSize(width: 100, height: 100)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "PrimaryButton")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "PrimaryButton") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    @Test("NavigationButton close style")
    func navigationButtonCloseSnapshot() throws {
        let view = NavigationButton(style: .close) { }
            .padding()
            .background(AppTheme.Colors.background)

        let size = CGSize(width: 100, height: 100)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "NavigationButton_Close")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "NavigationButton_Close") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }

    @Test("NavigationButton back style")
    func navigationButtonBackSnapshot() throws {
        let view = NavigationButton(style: .back) { }
            .padding()
            .background(AppTheme.Colors.background)

        let size = CGSize(width: 100, height: 100)
        guard let image = Snapshot.render(view, size: size) else {
            throw Snapshot.SnapshotError.failedToRenderView
        }

        if isRecording {
            try Snapshot.saveSnapshot(image, named: "NavigationButton_Back")
        } else {
            guard let reference = Snapshot.loadSnapshot(named: "NavigationButton_Back") else {
                throw Snapshot.SnapshotError.referenceNotFound
            }
            #expect(Snapshot.compare(image, reference))
        }
    }
}
