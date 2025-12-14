//
//  DebugMenu.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

#if DEBUG
import Pulse
import PulseUI
import SwiftUI

// MARK: - DebugMenuDestination

enum DebugMenuDestination: Hashable {
    case console
    case settings
}

// MARK: - DebugMenu

/// Debug menu accessible via shake gesture in DEBUG builds
public struct DebugMenu: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigationPath = NavigationPath()

    public init() { }

    public var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section("Network Debugging") {
                    NavigationLink(value: DebugMenuDestination.console) {
                        Label("Network Console", systemImage: "network")
                            .badge(Text("Live"))
                    }

                    NavigationLink(value: DebugMenuDestination.settings) {
                        Label("Pulse Settings", systemImage: "gearshape")
                    }
                }

                Section("Info") {
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("DEBUG")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Debug Menu")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DebugMenuDestination.self) { destination in
                switch destination {
                case .console:
                    ConsoleView()
                case .settings:
                    SettingsView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "\(version) (\(build))"
    }
}

// MARK: - Preview

#Preview {
    DebugMenu()
}
#endif
