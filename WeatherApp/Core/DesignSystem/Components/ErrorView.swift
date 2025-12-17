//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - ErrorView

struct ErrorView: View {
    let error: AppError
    let retryAction: (() -> Void)?

    init(error: AppError, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: error.iconName)
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.Colors.accent.opacity(0.8))

            VStack(spacing: AppTheme.Spacing.xs) {
                Text(error.errorDescription ?? "An error occurred")
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)

                if let suggestion = error.recoverySuggestion {
                    Text(suggestion)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }

            if let retryAction {
                Button(action: retryAction) {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(AppTheme.Colors.background)
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.accent)
                    .clipShape(Capsule())
                }
                .padding(.top, AppTheme.Spacing.sm)
            }
        }
        .padding(AppTheme.Spacing.lg)
    }
}

// MARK: - ErrorBanner

struct ErrorBanner: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)

            Text(message)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(.white)
                .lineLimit(2)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(Color.red.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
        .padding(.horizontal, AppTheme.Spacing.md)
    }
}

// MARK: - ToastModifier

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let isError: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if isPresented {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: isError ? "xmark.circle.fill" : "checkmark.circle.fill")
                        .foregroundStyle(isError ? .red : .green)

                    Text(message)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundStyle(.white)
                }
                .padding(AppTheme.Spacing.md)
                .background(Color.black.opacity(0.8))
                .clipShape(Capsule())
                .padding(.bottom, AppTheme.Spacing.xl)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
        .animation(.spring(response: 0.3), value: isPresented)
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String, isError: Bool = false) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, isError: isError))
    }
}

// MARK: - AlertErrorModifier

struct AlertErrorModifier: ViewModifier {
    @Binding var error: AppError?
    var retryAction: (() -> Void)?

    var isPresented: Binding<Bool> {
        Binding(
            get: { error != nil },
            set: { if !$0 { error = nil } }
        )
    }

    func body(content: Content) -> some View {
        content
            .alert(
                "Error",
                isPresented: isPresented,
                presenting: error
            ) { _ in
                if let retryAction {
                    Button("Try Again", action: retryAction)
                }
                Button("OK", role: .cancel) { }
            } message: { error in
                Text(error.errorDescription ?? "An unexpected error occurred")
            }
    }
}

extension View {
    func errorAlert(_ error: Binding<AppError?>, retryAction: (() -> Void)? = nil) -> some View {
        modifier(AlertErrorModifier(error: error, retryAction: retryAction))
    }
}

// MARK: - Preview

#Preview("Error View") {
    ZStack {
        WaveBackground()
        ErrorView(error: .noInternetConnection) {
            print("Retry tapped")
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Error Banner") {
    ZStack {
        Color.black
        VStack {
            ErrorBanner(message: "Failed to load weather data") { }
            Spacer()
        }
    }
    .preferredColorScheme(.dark)
}
