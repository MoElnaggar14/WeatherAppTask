//
//  AdapterProtocol.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

protocol AdapterProtocol {
    associatedtype Input
    associatedtype Output

    func adapt(_: Input) -> Output
}
