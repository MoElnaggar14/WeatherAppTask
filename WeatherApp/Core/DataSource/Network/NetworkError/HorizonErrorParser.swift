//
//  HorizonErrorParser.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation

struct HorizonErrorParser {
    func parse(_ error: Error) -> HorizonError {
        switch error {
        case let urlError as URLError:
            NetworkErrorToHorizonErrorAdapter().adapt(urlError)
        default:
            error as? HorizonError ?? .init(text: error.localizedDescription)
        }
    }

    func parse(_ data: Data) -> HorizonError {
        .somethingWentWrong
    }
}
