//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import WeatherAppSecrets

// MARK: - WeatherEndpoint

enum WeatherEndpoint {
    case weather(city: String)
    case weatherByCoordinates(lat: Double, lon: Double)
    case geocoding(query: String, limit: Int)
}

// MARK: Endpoint

extension WeatherEndpoint: Endpoint {
    var baseURL: String {
        switch self {
        case .weather,
             .weatherByCoordinates:
            #if DEBUG
            WeatherAppSecrets.Debug().baseURL
            #else
            WeatherAppSecrets.Release().baseURL
            #endif
        case .geocoding:
            "https://api.openweathermap.org/geo/1.0"
        }
    }

    var path: String {
        switch self {
        case .weather,
             .weatherByCoordinates:
            "weather"
        case .geocoding:
            "direct"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var parameters: Parameters? {
        var params = defaultParameters

        switch self {
        case .weather(let city):
            params["q"] = city
        case .weatherByCoordinates(let lat, let lon):
            params["lat"] = lat
            params["lon"] = lon
        case .geocoding(let query, let limit):
            params["q"] = query
            params["limit"] = limit
        }

        return params
    }
}
