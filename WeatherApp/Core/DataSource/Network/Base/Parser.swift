//
//  Parser.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

public struct Parser {
    func parse<T: Decodable>(_ data: Data, expectedType: T.Type) -> T? {
        data.decode(expectedType)
    }
}
