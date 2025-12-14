//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

// MARK: - WeatherEndpoint

enum WeatherEndpoint {
    case weather(city: String)
}

// MARK: Endpoint

extension WeatherEndpoint: Endpoint {
    var path: String {
        switch self {
        case .weather:
            "/data/2.5/weather"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .weather:
            .get
        }
    }

    var parameters: Parameters? {
        var params = defaultParameters

        switch self {
        case .weather(let city):
            params["q"] = city
        }

        return params
    }
}
