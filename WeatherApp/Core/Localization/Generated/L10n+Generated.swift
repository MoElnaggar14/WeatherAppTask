// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

public enum L10n {
  /// A label for the build version of the app.
  public static let build = L10n.tr("Build", fallback: "Build")

  /// The text that appears next to the "DEBUG" label in the "Your Prescriptions" section of the HomeView.
  public static let debug = L10n.tr("DEBUG", fallback: "DEBUG")

  /// The title of the debug menu.
  public static let debugMenu = L10n.tr("Debug Menu", fallback: "Debug Menu")

  /// The text for a button that dismisses a view.
  public static let done = L10n.tr("Done", fallback: "Done")

  /// A description under the search bar, instructing the user to enter at least 2 characters to search for a city.
  public static let enterAtLeast2CharactersToSearch = L10n.tr("Enter at least 2 characters to search", fallback: "Enter at least 2 characters to search")

  /// The title of an alert that displays an error.
  public static let error = L10n.tr("Error", fallback: "Error")

  /// A section in the debug menu that provides information about the app.
  public static let info = L10n.tr("Info", fallback: "Info")

  /// A badge indicating that the network console is currently in "live" mode.
  public static let live = L10n.tr("Live", fallback: "Live")

  /// A label for the network console option in the debug menu.
  public static let networkConsole = L10n.tr("Network Console", fallback: "Network Console")

  /// A section header in the debug menu for network debugging options.
  public static let networkDebugging = L10n.tr("Network Debugging", fallback: "Network Debugging")

  /// The label of a button that dismisses an alert.
  public static let ok = L10n.tr("OK", fallback: "OK")

  /// A menu item in the debug menu that navigates to the Pulse settings.
  public static let pulseSettings = L10n.tr("Pulse Settings", fallback: "Pulse Settings")

  /// A title displayed in the hint view of the `AddCityView`.
  public static let searchForACity = L10n.tr("Search for a city", fallback: "Search for a city")

  /// A button label that instructs the user to try again.
  public static let tryAgain = L10n.tr("Try Again", fallback: "Try Again")

  /// A label displayed alongside the version of the app.
  public static let version = L10n.tr("Version", fallback: "Version")

  public static let addingCity = L10n.tr("adding_city", fallback: "Adding city...")

  public static let appearance = L10n.tr("appearance", fallback: "Appearance")

  public static let cancel = L10n.tr("cancel", fallback: "Cancel")

  public static let citiesTitle = L10n.tr("cities_title", fallback: "Cities")

  public static let darkMode = L10n.tr("dark_mode", fallback: "Dark")

  public static let delete = L10n.tr("delete", fallback: "Delete")

  public static let deleteCity = L10n.tr("delete_city", fallback: "Delete City")

  public static let deleteCityConfirmation = L10n.tr("delete_city_confirmation", fallback: "Are you sure you want to delete this city?")

  public static let deleteWeatherRecord = L10n.tr("delete_weather_record", fallback: "Delete Weather Record")

  public static let deleteWeatherRecordConfirmation = L10n.tr("delete_weather_record_confirmation", fallback: "Are you sure you want to delete this weather record?")

  public static let enterCityPostcodeOrAirportLocation = L10n.tr("enter_city_postcode_or_airport_location", fallback: "Enter city, postcode, or airport location")

  public static let failedToAddCity = L10n.tr("failed_to_add_city", fallback: "Failed to add city")

  public static let historical = L10n.tr("historical", fallback: "Historical")

  public static let language = L10n.tr("language", fallback: "Language")

  public static let languageChangeNote = L10n.tr("language_change_note", fallback: "Changing language may require restarting the app")

  public static let languageChangeRestartMessage = L10n.tr("language_change_restart_message", fallback: "Please restart the app to apply the new language")

  public static let languageChanged = L10n.tr("language_changed", fallback: "Language Changed")

  public static let lightMode = L10n.tr("light_mode", fallback: "Light")

  public static let loadingWeather = L10n.tr("loading_weather", fallback: "Loading weather...")

  public static let noCitiesAddedYet = L10n.tr("no_cities_added_yet", fallback: "No cities added yet")

  public static let noResultsFound = L10n.tr("no_results_found", fallback: "No Results Found")

  public static let noWeatherData = L10n.tr("no_weather_data", fallback: "No Weather Data")

  public static let noWeatherHistory = L10n.tr("no_weather_history", fallback: "No Weather History")

  public static let pullToRefreshWeather = L10n.tr("pull_to_refresh_weather", fallback: "Pull to refresh weather data")

  public static let refresh = L10n.tr("refresh", fallback: "Refresh")

  public static let search = L10n.tr("search", fallback: "Search")

  public static let searching = L10n.tr("searching", fallback: "Searching...")

  public static let selectAnItem = L10n.tr("select_an_item", fallback: "Select an item")

  public static let settings = L10n.tr("settings", fallback: "Settings")

  public static let systemDefault = L10n.tr("system_default", fallback: "System Default")

  public static let tapToAddYourFirstCity = L10n.tr("tap_to_add_your_first_city", fallback: "Tap + to add your first city")

  public static let tryADifferentSearchTerm = L10n.tr("try_a_different_search_term", fallback: "Try a different search term")

  public static let unresolvedError = L10n.tr("unresolved_error", fallback: "Unresolved error")

  public static let viewWeather = L10n.tr("view_weather", fallback: "View Weather")

  public static let weatherApp = L10n.tr("weather_app", fallback: "WeatherApp")

  public static let weatherDataWillAppearHereAfterFetching = L10n.tr("weather_data_will_appear_here_after_fetching", fallback: "Weather data will appear here after fetching")

  public static func weatherInformationForReceivedOn(_ p1: CVarArg) -> String {
    return L10n.tr("weather_information_for_received_on", p1, fallback: "Weather information for %@")
  }

}

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = NSLocalizedString(key, bundle: .main, comment: "")
    return String(format: format != key ? format : value, locale: Locale.current, arguments: args)
  }
}