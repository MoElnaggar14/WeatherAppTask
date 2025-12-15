//
//  NetworkProtocol.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

protocol NetworkProtocol {
    func send<T: Decodable>(api: some Endpoint, model: T.Type) async throws -> T
}
