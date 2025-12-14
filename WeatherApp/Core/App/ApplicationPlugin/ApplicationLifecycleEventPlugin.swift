//
//  ApplicationLifecycleEventPlugin.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import UIKit

// MARK: - ApplicationLifecycleEventPlugin

@MainActor
public protocol ApplicationLifecycleEventPlugin: ApplicationPlugin {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool

    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillResignActive(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationWillTerminate(_ application: UIApplication)
}

public extension ApplicationLifecycleEventPlugin {
    func application(
        _: UIApplication,
        willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    )
        -> Bool { true }
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    )
        -> Bool { true }
    func application(
        _: UIApplication,
        continue _: NSUserActivity,
        restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void
    )
        -> Bool { false }

    func applicationProtectedDataWillBecomeUnavailable(_: UIApplication) { }
    func applicationProtectedDataDidBecomeAvailable(_: UIApplication) { }

    func applicationWillTerminate(_: UIApplication) { }
    func applicationDidReceiveMemoryWarning(_: UIApplication) { }

    func applicationDidBecomeActive(_: UIApplication) { }
    func applicationWillResignActive(_: UIApplication) { }
    func applicationDidEnterBackground(_: UIApplication) { }
    func applicationWillEnterForeground(_: UIApplication) { }
}
