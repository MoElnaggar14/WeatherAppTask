//
//  LogPlugin.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import SwiftMoLogger
import UIKit

// MARK: - LogPlugin

struct LogPlugin { }

// MARK: ApplicationLifecycleEventPlugin

extension LogPlugin: ApplicationLifecycleEventPlugin {
    func applicationDidBecomeActive(_ application: UIApplication) {
        SwiftMoLogger.info("📱 App became active")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        SwiftMoLogger.info("📱 App will resign active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SwiftMoLogger.info("📱 App entered background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        SwiftMoLogger.info("📱 App will enter foreground")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SwiftMoLogger.warn("📱 App will terminate")
    }
}
