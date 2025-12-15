// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
// Swift 6 compliant with strict concurrency

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum AppColors: Sendable {
  public static let accentColor = ColorAsset(name: "AccentColor")
  public static let background = ColorAsset(name: "Background")
  public static let cardBackground = ColorAsset(name: "CardBackground")
  public static let primaryText = ColorAsset(name: "PrimaryText")
  public static let secondaryBackground = ColorAsset(name: "SecondaryBackground")
  public static let secondaryText = ColorAsset(name: "SecondaryText")
  public static let separator = ColorAsset(name: "Separator")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ColorAsset: Sendable {
  public let name: String

  #if os(macOS)
  public typealias PlatformColor = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias PlatformColor = UIColor
  #endif

  /// UIKit/AppKit color (MainActor isolated)
  @MainActor
  public var uiColor: PlatformColor {
    guard let color = PlatformColor(named: name, in: .main, compatibleWith: nil) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }

  #if os(iOS) || os(tvOS)
  @MainActor
  public func uiColor(compatibleWith traitCollection: UITraitCollection) -> PlatformColor {
    guard let color = PlatformColor(named: name, in: .main, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif
}

// MARK: - SwiftUI Integration

#if canImport(SwiftUI)
extension ColorAsset {
  /// SwiftUI Color - can be used directly in SwiftUI views
  public var color: SwiftUI.Color {
    SwiftUI.Color(name, bundle: .main)
  }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  /// Initialize Color from ColorAsset
  init(_ asset: ColorAsset) {
    self.init(asset.name, bundle: .main)
  }
}
#endif
