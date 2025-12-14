//
//  NetworkDebuggerPlugin.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

#if DEBUG
import Foundation
import Pulse
import SwiftMoLogger
import UIKit

// MARK: - NetworkDebuggerPlugin

/// Plugin that enables Pulse network debugging in DEBUG builds only
struct NetworkDebuggerPlugin { }

// MARK: - ApplicationLifecycleEventPlugin

extension NetworkDebuggerPlugin: ApplicationLifecycleEventPlugin {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupPulseNetworkLogging()
        return true
    }

    // MARK: - Private Methods

    private func setupPulseNetworkLogging() {
        SwiftMoLogger.debug("🔍 Enabling Pulse network debugger...", tag: .network)

        // Enable URLSession logging
        URLSessionProxyDelegate.enableAutomaticRegistration()

        SwiftMoLogger.debug("✅ Pulse network debugger enabled", tag: .network)
        SwiftMoLogger.info("💡 Shake device to access Pulse console", tag: .network)
    }
}
#endif
