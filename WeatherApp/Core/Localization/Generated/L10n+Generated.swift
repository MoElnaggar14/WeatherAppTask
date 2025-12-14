// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

public enum L10n {
  /// A text label that combines "Item at" with a formatted timestamp.
  public static let addItem = L10n.tr("add_item", fallback: "Add Item")

  public static let citiesTitle = L10n.tr("cities_title", fallback: "Cities")

  public static let itemAt = L10n.tr("item_at", fallback: "Item at")

  public static let selectAnItem = L10n.tr("select_an_item", fallback: "Select an item")

  public static let unresolvedError = L10n.tr("unresolved_error", fallback: "Unresolved error")

  public static let weatherApp = L10n.tr("weather_app", fallback: "WeatherApp")

}

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = NSLocalizedString(key, bundle: .main, comment: "")
    return String(format: format != key ? format : value, locale: Locale.current, arguments: args)
  }
}
