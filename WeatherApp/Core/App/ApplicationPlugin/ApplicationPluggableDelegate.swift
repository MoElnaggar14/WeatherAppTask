//
//  ApplicationPluggableDelegate.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import UIKit.UIApplication
import UIKit.UIWindow

// MARK: - ApplicationPluggableDelegate

/// Subclassed by the `AppDelegate` to pass lifecycle events to loaded plugins.
///
/// The application plugins will be processed in sequence after calling `plugins() -> [ApplicationPlugin]`.
///
///
///     class AppDelegate: ApplicationPluggableDelegate {
///
///         override func plugins() -> [ApplicationPlugin] {[
///             FirebaseCorePlugin(),
///             NotificationsPlugin(),
///             FirebaseMessagingPlugin()
///         ]}
///     }
///
/// Each application plugin has access to the `AppDelegate` lifecycle events.
@MainActor
open class ApplicationPluggableDelegate: UIResponder {
    public var window: UIWindow?

    /// List of application plugins for binding to `AppDelegate` events
    public private(set) lazy var pluginInstances: [ApplicationPlugin] = plugins()

    override public init() {
        super.init()

        // Load lazy property early
        _ = pluginInstances
    }

    /// List of application plugins for binding to `AppDelegate` events
    open func plugins() -> [ApplicationPlugin] { [] } // Override
}

// MARK: UIApplicationDelegate

extension ApplicationPluggableDelegate: UIApplicationDelegate {
    open func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Ensure all delegates called even if condition fails early
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }.reduce(true) {
            $0 && $1.application(application, willFinishLaunchingWithOptions: launchOptions)
        }
    }

    open func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Ensure all delegates called even if condition fails early
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }.reduce(true) {
            $0 && $1.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }

    open func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationProtectedDataWillBecomeUnavailable(application) }
    }

    open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationProtectedDataDidBecomeAvailable(application) }
    }

    open func applicationWillTerminate(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationWillTerminate(application) }
    }

    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationDidReceiveMemoryWarning(application) }
    }

    open func applicationDidBecomeActive(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationDidBecomeActive(application) }
    }

    open func applicationWillResignActive(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationWillResignActive(application) }
    }

    open func applicationDidEnterBackground(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationDidEnterBackground(application) }
    }

    open func applicationWillEnterForeground(_ application: UIApplication) {
        pluginInstances.compactMap { $0 as? ApplicationLifecycleEventPlugin }
            .forEach { $0.applicationWillEnterForeground(application) }
    }
}
