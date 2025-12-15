//
//  LocalizationTests.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation
import Testing
@testable import WeatherApp

// MARK: - Localization Tests

@Suite("Localization Tests")
@MainActor
struct LocalizationTests {
    @Test("L10n has cities title")
    func l10nHasCitiesTitle() {
        #expect(!L10n.citiesTitle.isEmpty)
    }

    @Test("L10n has delete text")
    func l10nHasDeleteText() {
        #expect(!L10n.delete.isEmpty)
    }

    @Test("L10n has no cities added yet text")
    func l10nHasNoCitiesAddedYet() {
        #expect(!L10n.noCitiesAddedYet.isEmpty)
    }

    @Test("L10n weather information function works")
    func l10nWeatherInformationFunction() {
        let result = L10n.weatherInformationForReceivedOn("LONDON")
        #expect(result.contains("LONDON"))
    }
}
