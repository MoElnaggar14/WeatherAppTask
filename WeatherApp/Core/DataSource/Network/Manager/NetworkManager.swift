//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

final class NetworkManager: NetworkProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<T: Decodable>(api: some Endpoint, model: T.Type) async throws -> T {
        let request = URLRequestFactory.generateRequest(outOf: api)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HorizonError.inValidResponse
        }
        guard httpResponse.statusCode.isInSuccessRange else {
            throw HorizonError(text: "status code \(httpResponse.statusCode)")
        }

        guard let successModel = Parser().parse(data, expectedType: model) else {
            throw HorizonErrorParser().parse(data)
        }
        return successModel
    }
}
