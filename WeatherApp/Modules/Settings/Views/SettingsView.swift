//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings = SettingsManager.shared
    @State private var showLanguageRestartAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                List {
                    // Appearance Section
                    Section {
                        ForEach(AppThemeMode.allCases) { mode in
                            ThemeOptionRow(
                                mode: mode,
                                isSelected: settings.themeMode == mode
                            ) {
                                withAnimation {
                                    settings.themeMode = mode
                                }
                            }
                        }
                    } header: {
                        SectionHeader(title: L10n.appearance, icon: "paintbrush.fill")
                    }

                    // Language Section
                    Section {
                        ForEach(AppLanguage.allCases) { language in
                            LanguageOptionRow(
                                language: language,
                                isSelected: settings.language == language
                            ) {
                                if settings.language != language {
                                    settings.language = language
                                    if language != .system {
                                        showLanguageRestartAlert = true
                                    }
                                }
                            }
                        }
                    } header: {
                        SectionHeader(title: L10n.language, icon: "globe")
                    } footer: {
                        Text(L10n.languageChangeNote)
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.secondaryText)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(L10n.settings)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.done) {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(settings.themeMode.colorScheme)
        .alert(L10n.languageChanged, isPresented: $showLanguageRestartAlert) {
            Button(L10n.ok, role: .cancel) { }
        } message: {
            Text(L10n.languageChangeRestartMessage)
        }
    }
}

// MARK: - SectionHeader

private struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.Colors.accent)
            Text(title)
        }
        .font(AppTheme.Typography.subheadline)
        .textCase(nil)
    }
}

// MARK: - ThemeOptionRow

private struct ThemeOptionRow: View {
    let mode: AppThemeMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: mode.iconName)
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? AppTheme.Colors.accent : AppTheme.Colors.secondaryText)
                    .frame(width: 28)

                Text(mode.displayName)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.Colors.accent)
                        .font(.system(size: 20))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - LanguageOptionRow

private struct LanguageOptionRow: View {
    let language: AppLanguage
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Text(language.flagEmoji)
                    .font(.system(size: 24))
                    .frame(width: 28)

                Text(language.displayName)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.Colors.accent)
                        .font(.system(size: 20))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
