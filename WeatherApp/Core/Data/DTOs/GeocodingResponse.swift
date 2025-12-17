//
//  GeocodingResponse.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 15/12/2025.
//

import Foundation

// MARK: - GeocodingResponse

struct GeocodingResponse: Codable {
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat
        case lon
        case country
        case state
    }
}

// MARK: - Domain Mapping

extension GeocodingResponse {
    var toDomain: CitySearchResult {
        CitySearchResult(
            name: name,
            country: country,
            state: state,
            latitude: lat,
            longitude: lon,
            displayName: formattedDisplayName
        )
    }

    private var formattedDisplayName: String {
        var components = [name]
        if let state, !state.isEmpty {
            components.append(state)
        }
        components.append(country)
        return components.joined(separator: ", ")
    }
}

// MARK: - CitySearchResult

struct CitySearchResult: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let state: String?
    let latitude: Double
    let longitude: Double
    let displayName: String

    var cityNameForWeather: String {
        if let state {
            return "\(name),\(state),\(country)"
        }
        return "\(name),\(country)"
    }
}
