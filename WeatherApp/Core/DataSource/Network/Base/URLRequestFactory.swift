//
//  URLRequestFactory.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import SwiftMoLogger

// MARK: - URLRequestFactory

enum URLRequestFactory {
    /// Generates URLRequest after building the URL, injecting the method and the headers
    /// and encoding the Parameters suitably according to the endpoint
    /// - Parameter endpoint: the protocol that carries the details of the request
    /// - Returns: URLRequest for the manager to use
    static func generateRequest(outOf endpoint: Endpoint) -> URLRequest {
        let url = generateURL(outOf: endpoint)
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = endpoint.method.rawValue

        for (key, value) in endpoint.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        encodeRequestWithParameters(&urlRequest, from: endpoint)

        return urlRequest
    }
}

private extension URLRequestFactory {
    /// Generates URL out of endpoint protocol
    /// - Parameter endpoint: the protocol that carries the details of the request
    /// - Returns: the URL to be used to build the URLRequest
    private static func generateURL(outOf endpoint: Endpoint) -> URL {
        guard let url = URL(string: endpoint.baseURL)?.appendingPathComponent(endpoint.path) else {
            // We used a fatalError here with a helpful message so that if we had a
            // typo in the path or the baseURL, this fatalError notifies us, Normally
            // i'd go for an assertionFailure so it doesn't crash the app in
            // production, but since am sure this won't happen in production but only
            // in development, so I don't see anything wrong with it
            SwiftMoLogger.error("You probably passed a wrong URL,\n check \(endpoint.baseURL) or \(endpoint.path)", tag: .api)
            fatalError("You probably passed a wrong URL,\n check \(endpoint.baseURL) or \(endpoint.path)")
        }
        return url
    }

    /// Encodes the parameters in the URL
    private static func encodeParametersInURL(in urlRequest: inout URLRequest, endpoint: Endpoint) {
        guard let url = urlRequest.url?.absoluteString else { return }
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = endpoint.parameters?.map { key, value in
            .init(name: key, value: value as? String ?? "")
        }

        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        urlRequest.url = urlComponents.url
    }

    /// Encodes the parameters in the Request Body
    private static func encodeParametersInBodyOfRequest(in request: inout URLRequest, endpoint: Endpoint) {
        do {
            let data = try JSONSerialization.data(withJSONObject: endpoint.parameters ?? [], options: [])
            request.httpBody = data
        } catch {
            SwiftMoLogger.error("Failed to encode parameters in body: \(error)", tag: .network)
        }
    }

    /// Handles How the parameters will be encoded according to the endpoint encoding
    private static func encodeRequestWithParameters(_ request: inout URLRequest, from endpoint: Endpoint) {
        switch endpoint.encoding {
        case .urlEncoding,
             .httpBody:
            encodeParametersInURL(in: &request, endpoint: endpoint)
        case .jsonEncoding:
            encodeParametersInBodyOfRequest(in: &request, endpoint: endpoint)
        case .multipartEncoding:
            break
        }
    }
}
