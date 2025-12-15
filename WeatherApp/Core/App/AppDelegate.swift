//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import SwiftMoLogger
import UIKit

// MARK: - AppDelegate

class AppDelegate: ApplicationPluggableDelegate {
    // MARK: - Plugin Configuration

    override func plugins() -> [ApplicationPlugin] {
        isUnitTesting ? testingPlugins : defaultPlugins
    }

    /// Default plugins for normal app execution
    /// Order matters: plugins are executed in sequence
    var defaultPlugins: [ApplicationPlugin] {
        var plugins: [ApplicationPlugin] = [
            LogPlugin(),
        ]

        #if DEBUG
        plugins.insert(NetworkDebuggerPlugin(), at: 1)
        #endif

        return plugins
    }

    /// Minimal plugins for unit testing
    var testingPlugins: [ApplicationPlugin] {
        [
            LogPlugin(),
        ]
    }
}

// MARK: - Testing Detection

extension AppDelegate {
    var isUnitTesting: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
