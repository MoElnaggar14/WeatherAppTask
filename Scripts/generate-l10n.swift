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
        guard let englishValue = entry.localizations?["en"]?.stringUnit?.value else {
            continue
        }

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
                let swiftKey = item.key.replacingOccurrences(of: ".", with: "_")
                    .split(separator: "_")
                    .enumerated()
                    .map { index, part in
                        index == 0 ? part.lowercased() : part.capitalized
                    }
                    .joined()

                if let comment = item.comment {
                    output += "  /// \(comment)\n"
                }
                let escapedValue = item.value
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "\n", with: "\\n")
                output += "  public static let \(swiftKey) = L10n.tr(\"\(item.key)\", fallback: \"\(escapedValue)\")\n\n"
            }
        } else {
            // Nested enum
            let enumName = groupName.capitalized
            output += "  public enum \(enumName) {\n"

            for item in items {
                let swiftKey = item.key.replacingOccurrences(of: ".", with: "_")
                    .split(separator: "_")
                    .enumerated()
                    .map { index, part in
                        index == 0 ? part.lowercased() : part.capitalized
                    }
                    .joined()

                if let comment = item.comment {
                    output += "    /// \(comment)\n"
                }
                let fullKey = "\(groupName).\(item.key)"
                let escapedValue = item.value
                    .replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "\n", with: "\\n")
                output += "    public static let \(swiftKey) = L10n.tr(\"\(fullKey)\", fallback: \"\(escapedValue)\")\n"
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
