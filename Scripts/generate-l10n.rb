#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to generate type-safe L10n from .xcstrings file
# Swift 6 compatible output

require 'json'
require 'fileutils'

INPUT_FILE = 'Packages/Content/Sources/Content/Resources/Localizable.xcstrings'
OUTPUT_FILE = 'Packages/Content/Sources/Content/Generated/L10n+Generated.swift'

def to_swift_identifier(key)
  # Convert dot-separated key to camelCase identifier
  # e.g., "common.ok" -> "ok", "onboarding.page1.title" -> "page1Title"
  parts = key.split('.')
  # Skip the first part (prefix) and create camelCase from the rest
  remaining = parts[1..-1]
  if remaining.length == 1
    remaining.first
            .gsub(/[^a-zA-Z0-9]/, '_')
            .gsub(/^(\d)/, '_\1')
  else
    # CamelCase: first word lowercase, rest capitalized
    first = remaining.first.gsub(/[^a-zA-Z0-9]/, '_').gsub(/^(\d)/, '_\1')
    rest = remaining[1..-1].map { |p| p.split(/[^a-zA-Z0-9]/).map(&:capitalize).join }
    (first + rest.join).gsub(/^(\d)/, '_\1')
  end
end

def to_swift_enum_name(prefix)
  # Convert prefix to PascalCase enum name
  # e.g., "common" -> "Common", "dhikr" -> "Dhikr"
  prefix.split(/[._-]/).map(&:capitalize).join
end

def is_swift_keyword?(name)
  swift_keywords = %w[continue return default case switch if else for while do try catch throw import class struct enum protocol extension func var let static private public internal fileprivate open final override required convenience init deinit subscript typealias associatedtype where self Self super nil true false as is in out inout mutating nonmutating throws rethrows async await]
  swift_keywords.include?(name)
end

def escape_swift_keyword(name)
  is_swift_keyword?(name) ? "`#{name}`" : name
end

def generate_swift_code(strings_data)
  # Group strings by their prefix (first part before dot)
  grouped = {}

  strings_data['strings'].each do |key, _value|
    parts = key.split('.')
    prefix = parts.first
    grouped[prefix] ||= []
    grouped[prefix] << key
  end

  code = <<~SWIFT
    // swiftlint:disable all
    // Generated from Localizable.xcstrings - DO NOT EDIT
    // Run 'rake l10n' to regenerate

    import Foundation
    import SwiftUI

    // MARK: - L10n Generated

    public enum L10n: Sendable {
  SWIFT

  # Sort groups alphabetically
  grouped.keys.sort.each do |prefix|
    enum_name = to_swift_enum_name(prefix)
    keys = grouped[prefix].sort

    code += "\n    // MARK: - #{enum_name}\n\n"
    code += "    public enum #{enum_name}: Sendable {\n"

    keys.each do |key|
      identifier = to_swift_identifier(key)
      safe_identifier = escape_swift_keyword(identifier)

      # LocalizedStringKey property (for SwiftUI)
      code += "        public static var #{safe_identifier}: LocalizedStringKey { \"#{key}\" }\n"
    end

    code += "\n"

    keys.each do |key|
      identifier = to_swift_identifier(key)
      # For String versions, use plain identifier with String suffix (no backticks needed)
      string_identifier = is_swift_keyword?(identifier) ? "#{identifier}String" : "#{identifier}String"

      # String property (for non-SwiftUI contexts)
      code += "        public static var #{string_identifier}: String { String(localized: \"#{key}\", bundle: .module) }\n"
    end

    code += "    }\n"
  end

  code += <<~SWIFT
  }

  // MARK: - String Extension

  public extension String {
      /// Localizes the string using the Content module bundle
      var localized: String {
          String(localized: String.LocalizationValue(self), bundle: .module)
      }

      /// Localizes the string with arguments
      func localized(with arguments: CVarArg...) -> String {
          String(format: localized, arguments: arguments)
      }
  }

  // MARK: - LocalizedStringKey Extension

  public extension LocalizedStringKey {
      /// Creates a localized string key from the Content module
      init(content key: String) {
          self.init(key)
      }
  }
  SWIFT

  code
end

# Main execution
puts "🌍 Generating L10n from xcstrings..."

unless File.exist?(INPUT_FILE)
  puts "❌ Error: #{INPUT_FILE} not found"
  exit 1
end

# Parse the xcstrings JSON file
json_content = File.read(INPUT_FILE)
strings_data = JSON.parse(json_content)

# Generate Swift code
swift_code = generate_swift_code(strings_data)

# Ensure output directory exists
FileUtils.mkdir_p(File.dirname(OUTPUT_FILE))

# Write the generated file
File.write(OUTPUT_FILE, swift_code)

puts "✅ Generated #{OUTPUT_FILE}"
puts "   Found #{strings_data['strings'].keys.count} localization keys"
