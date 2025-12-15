//
//  WaveBackground.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import SwiftUI

// MARK: - WaveBackground

struct WaveBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    WaveShape()
                        .fill(waveGradient)
                        .frame(height: geometry.size.height * 0.35)
                }
                .ignoresSafeArea()
            }
        }
    }

    private var waveGradient: LinearGradient {
        LinearGradient(
            colors: [
                waveColor.opacity(0.3),
                waveColor.opacity(0.15),
                waveColor.opacity(0.05),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var waveColor: Color {
        colorScheme == .dark ? Color.white : Color.gray
    }
}

// MARK: - WaveShape

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: 0, y: height * 0.4))

        // First wave
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.2),
            control1: CGPoint(x: width * 0.15, y: height * 0.1),
            control2: CGPoint(x: width * 0.35, y: height * 0.35)
        )

        // Second wave
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.3),
            control1: CGPoint(x: width * 0.65, y: height * 0.05),
            control2: CGPoint(x: width * 0.85, y: height * 0.25)
        )

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}

// MARK: - Preview

#Preview("Dark Mode") {
    WaveBackground()
        .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    WaveBackground()
        .preferredColorScheme(.light)
}
