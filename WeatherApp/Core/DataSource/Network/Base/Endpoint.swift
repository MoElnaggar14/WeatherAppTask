//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import WeatherAppSecrets

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

// MARK: - Endpoint

protocol Endpoint {
    var baseURL: String { get }

    var path: String { get }

    var headers: HTTPHeaders { get }

    var parameters: Parameters? { get }

    var method: HTTPMethod { get }

    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    var baseURL: String {
        #if DEBUG
        WeatherAppSecrets.Debug().baseURL
        #elseif RELEASE
        WeatherAppSecrets.Release().baseURL
        #endif
    }

    var headers: HTTPHeaders {
        [:]
    }

    var defaultParameters: Parameters {
        var apiKey: String {
            #if DEBUG
            WeatherAppSecrets.Debug().apiKey
            #elseif RELEASE
            WeatherAppSecrets.Release().apiKey
            #endif
        }

        var parameters = Parameters()
        parameters["appid"] = apiKey

        return parameters
    }

    var encoding: ParameterEncoding {
        switch method {
        case .post:
            .jsonEncoding
        case .get:
            .urlEncoding
        case .delete:
            .jsonEncoding
        case .put:
            .jsonEncoding
        case .patch:
            .jsonEncoding
        }
    }
}
