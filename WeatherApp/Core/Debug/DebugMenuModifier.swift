//
//  DebugMenuModifier.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

#if DEBUG
import SwiftUI

// MARK: - DebugMenuModifier

/// View modifier that shows debug menu on shake gesture
public struct DebugMenuModifier: ViewModifier {
    @State private var isShowingDebugMenu = false

    public init() { }

    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                isShowingDebugMenu = true
            }
            .sheet(isPresented: $isShowingDebugMenu) {
                DebugMenu()
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds debug menu accessible via shake gesture (DEBUG builds only)
    func debugMenu() -> some View {
        modifier(DebugMenuModifier())
    }
}

// MARK: - UIDevice Shake Detection

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}

// MARK: - UIWindow Shake Detection

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
        super.motionEnded(motion, with: event)
    }
}
#endif
