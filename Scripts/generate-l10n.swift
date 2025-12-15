#!/usr/bin/swift

import Foundation

// MARK: - StringCatalog

struct StringCatalog: Codable {
    let sourceLanguage: String
    let strings: [String: StringEntry]
    let version: String
}

// MARK: - StringEntry

struct StringEntry: Codable {
    let extractionState: String?
    let localizations: [String: Localization]?
    let comment: String?
}

// MARK: - Localization

struct Localization: Codable {
    let stringUnit: StringUnit?
    let variations: Variations?
}

// MARK: - StringUnit

struct StringUnit: Codable {
    let state: String
    let value: String
}

// MARK: - Variations

struct Variations: Codable {
    // Handle plural variations if needed
}

// MARK: - Helpers

// Converts a localization key to a valid Swift identifier
func convertToSwiftIdentifier(_ key: String) -> String {
    // Remove any characters that aren't alphanumeric, underscore, or space
    let cleaned = key.filter { $0.isLetter || $0.isNumber || $0 == "_" || $0 == " " }

    // If the key is empty after cleaning, return empty string
    guard !cleaned.isEmpty else { return "" }

    // Split by spaces and underscores, then convert to camelCase
    let words = cleaned
        .replacingOccurrences(of: "_", with: " ")
        .split(separator: " ")
        .map { String($0) }

    guard !words.isEmpty else { return "" }

    let result = words.enumerated().map { index, word in
        if index == 0 {
            word.lowercased()
        } else {
            word.capitalized
        }
    }.joined()

    // Ensure the identifier doesn't start with a number
    if let first = result.first, first.isNumber {
        return "_" + result
    }

    return result
}

// Extracts format specifiers from a string and returns Swift types
func extractFormatSpecifiers(_ string: String) -> [String] {
    var specifiers: [String] = []

    // Match format specifiers like %@, %d, %f, %1$@, %2$d, etc.
    let pattern = #"%(\d+\$)?([a-zA-Z@])"#

    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
        return []
    }

    let range = NSRange(string.startIndex ..< string.endIndex, in: string)
    let matches = regex.matches(in: string, options: [], range: range)

    for match in matches {
        if let specifierRange = Range(match.range(at: 2), in: string) {
            let specifier = String(string[specifierRange])
            switch specifier {
            case "@":
                specifiers.append("CVarArg")
            case "d",
                 "i",
                 "u",
                 "x",
                 "X",
                 "o":
                specifiers.append("Int")
            case "f",
                 "e",
                 "E",
                 "g",
                 "G":
                specifiers.append("Double")
            case "s":
                specifiers.append("String")
            default:
                specifiers.append("CVarArg")
            }
        }
    }

    return specifiers
}

// MARK: - Generator

func generateL10nFile(from catalogPath: String, outputPath: String) throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: catalogPath))
    let catalog = try JSONDecoder().decode(StringCatalog.self, from: data)

    var output = """
        // swiftlint:disable all
        // Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

        import Foundation

        // MARK: - Strings

        public enum L10n {

        """

    // Group strings by their prefix (e.g., "tabs", "authentication", etc.)
    var groups: [String: [(key: String, value: String, comment: String?)]] = [:]

    for (key, entry) in catalog.strings.sorted(by: { $0.key < $1.key }) {
        // Get English value from localizations, or use the key itself as the value
        let englishValue = entry.localizations?["en"]?.stringUnit?.value ?? key

        let components = key.split(separator: ".")
        if components.count > 1 {
            let groupName = String(components[0])
            let subKey = components.dropFirst().joined(separator: ".")

            if groups[groupName] == nil {
                groups[groupName] = []
            }
            groups[groupName]?.append((key: subKey, value: englishValue, comment: entry.comment))
        } else {
            if groups[""] == nil {
                groups[""] = []
            }
            groups[""]?.append((key: key, value: englishValue, comment: entry.comment))
        }
    }

    // Generate nested enums for each group
    for (groupName, items) in groups.sorted(by: { $0.key < $1.key }) {
        if groupName.isEmpty {
            // Top-level keys
            for item in items {
                let swiftKey = convertToSwiftIdentifier(item.key)

                // Skip keys that can't be converted to valid identifiers
                guard !swiftKey.isEmpty else { continue }

                // Check if value has format specifiers
                let formatSpecifiers = extractFormatSpecifiers(item.value)

                if let comment = item.comment {
                    output += "  /// \(comment)\n"
                }
                let escapedValue = item.value
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "\n", with: "\\n")

                if formatSpecifiers.isEmpty {
                    output += "  public static let \(swiftKey) = L10n.tr(\"\(item.key)\", fallback: \"\(escapedValue)\")\n\n"
                } else {
                    // Generate function for strings with format specifiers
                    let params = formatSpecifiers.enumerated().map { "_ p\($0.offset + 1): \($0.element)" }.joined(separator: ", ")
                    let args = formatSpecifiers.enumerated().map { "p\($0.offset + 1)" }.joined(separator: ", ")
                    output += "  public static func \(swiftKey)(\(params)) -> String {\n"
                    output += "    return L10n.tr(\"\(item.key)\", \(args), fallback: \"\(escapedValue)\")\n"
                    output += "  }\n\n"
                }
            }
        } else {
            // Nested enum
            let enumName = groupName.capitalized
            output += "  public enum \(enumName) {\n"

            for item in items {
                let swiftKey = convertToSwiftIdentifier(item.key)

                // Skip keys that can't be converted to valid identifiers
                guard !swiftKey.isEmpty else { continue }

                // Check if value has format specifiers
                let formatSpecifiers = extractFormatSpecifiers(item.value)

                if let comment = item.comment {
                    output += "    /// \(comment)\n"
                }
                let fullKey = "\(groupName).\(item.key)"
                let escapedValue = item.value
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "\n", with: "\\n")

                if formatSpecifiers.isEmpty {
                    output += "    public static let \(swiftKey) = L10n.tr(\"\(fullKey)\", fallback: \"\(escapedValue)\")\n"
                } else {
                    // Generate function for strings with format specifiers
                    let params = formatSpecifiers.enumerated().map { "_ p\($0.offset + 1): \($0.element)" }.joined(separator: ", ")
                    let args = formatSpecifiers.enumerated().map { "p\($0.offset + 1)" }.joined(separator: ", ")
                    output += "    public static func \(swiftKey)(\(params)) -> String {\n"
                    output += "      return L10n.tr(\"\(fullKey)\", \(args), fallback: \"\(escapedValue)\")\n"
                    output += "    }\n"
                }
            }

            output += "  }\n\n"
        }
    }

    output += """
        }

        // MARK: - Implementation Details

        extension L10n {
          private static func tr(_ key: String, _ args: CVarArg..., fallback value: String) -> String {
            let format = NSLocalizedString(key, bundle: .main, comment: "")
            return String(format: format != key ? format : value, locale: Locale.current, arguments: args)
          }
        }
        """

    try output.write(toFile: outputPath, atomically: true, encoding: .utf8)
    print("✅ Generated L10n file at: \(outputPath)")
}

// MARK: - Main

guard CommandLine.arguments.count == 3 else {
    print("Usage: generate-l10n.swift <input.xcstrings> <output.swift>")
    exit(1)
}

let inputPath = CommandLine.arguments[1]
let outputPath = CommandLine.arguments[2]

do {
    try generateL10nFile(from: inputPath, outputPath: outputPath)
} catch {
    print("❌ Error: \(error)")
    exit(1)
}
