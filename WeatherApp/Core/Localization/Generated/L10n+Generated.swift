// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

public enum L10n {
  /// A label for the build version of the app.
  public static let build = L10n.tr("Build", fallback: "Build")

  /// The text of a button that dismisses the current view.
  public static let cancel = L10n.tr("Cancel", fallback: "Cancel")

  /// The text that appears next to the "DEBUG" label in the "Your Prescriptions" section of the HomeView.
  public static let debug = L10n.tr("DEBUG", fallback: "DEBUG")

  /// The title of the debug menu.
  public static let debugMenu = L10n.tr("Debug Menu", fallback: "Debug Menu")

  /// A menu option to delete an item.
  public static let delete = L10n.tr("Delete", fallback: "Delete")

  /// The text for a button that dismisses a view.
  public static let done = L10n.tr("Done", fallback: "Done")

  /// A prompt text in the "Add City" view, instructing the user to enter a city, postcode, or airport location.
  public static let enterCityPostcodeOrAirportLocation = L10n.tr("Enter city, postcode or airport location", fallback: "Enter city, postcode or airport location")

  /// A section in the debug menu that provides information about the app.
  public static let info = L10n.tr("Info", fallback: "Info")

  /// A badge indicating that the network console is currently in "live" mode.
  public static let live = L10n.tr("Live", fallback: "Live")

  /// A label for the network console option in the debug menu.
  public static let networkConsole = L10n.tr("Network Console", fallback: "Network Console")

  /// A section header in the debug menu for network debugging options.
  public static let networkDebugging = L10n.tr("Network Debugging", fallback: "Network Debugging")

  /// A description displayed when a user hasn't added any cities to their list.
  public static let noCitiesAddedYet = L10n.tr("No cities added yet", fallback: "No cities added yet")

  /// A message displayed when no search results are found.
  public static let noResultsFound = L10n.tr("No results found", fallback: "No results found")

  /// A description displayed when there is no weather data available for a city.
  public static let noWeatherData = L10n.tr("No weather data", fallback: "No weather data")

  /// A description displayed when a city has no weather history.
  public static let noWeatherHistory = L10n.tr("No weather history", fallback: "No weather history")

  /// A menu item in the debug menu that navigates to the Pulse settings.
  public static let pulseSettings = L10n.tr("Pulse Settings", fallback: "Pulse Settings")

  /// A placeholder text for a search bar.
  public static let search = L10n.tr("Search", fallback: "Search")

  /// A description of the action to add a city in the "No cities added yet" state of the cities list view.
  public static let tapToAddYourFirstCity = L10n.tr("Tap + to add your first city", fallback: "Tap + to add your first city")

  /// A description below the message indicating that no results were found, encouraging the user to try a different search term.
  public static let tryADifferentSearchTerm = L10n.tr("Try a different search term", fallback: "Try a different search term")

  /// A label displayed alongside the version of the app.
  public static let version = L10n.tr("Version", fallback: "Version")

  /// A button label that says "View Weather".
  public static let viewWeather = L10n.tr("View Weather", fallback: "View Weather")

  /// A label at the bottom of the weather detail view that shows the date and time when the weather data was last fetched. The argument is the name of the city.
  public static func weatherInformationForReceivedOn(_ p1: CVarArg) -> String {
    return L10n.tr("WEATHER INFORMATION FOR %@ RECEIVED ON", p1, fallback: "WEATHER INFORMATION FOR %@ RECEIVED ON")
  }

  /// A description of what will happen when weather data is fetched.
  public static let weatherDataWillAppearHereAfterFetching = L10n.tr("Weather data will appear here after fetching", fallback: "Weather data will appear here after fetching")

  public static let citiesTitle = L10n.tr("cities_title", fallback: "Cities")

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