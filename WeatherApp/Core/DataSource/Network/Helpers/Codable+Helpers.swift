//
//  Codable+Helpers.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import Foundation
import SwiftMoLogger

extension Encodable {
    var asDictionary: [String: Any] {
        let serialized = (try? JSONSerialization.jsonObject(with: encode, options: .allowFragments))
        return serialized as? [String: Any] ?? [String: Any]()
    }

    var encode: Data {
        (try? JSONEncoder().encode(self)) ?? Data()
    }
}

extension Data {
    func decode<T: Decodable>(_ object: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try (decoder.decode(T.self, from: self))
        } catch DecodingError.keyNotFound(let key, let context) {
            SwiftMoLogger.error("could not find key \(key) in JSON: \(context.debugDescription)", tag: .parsing)
        } catch DecodingError.valueNotFound(let type, let context) {
            SwiftMoLogger.error("could not find type \(type) in JSON: \(context.debugDescription)", tag: .parsing)
        } catch DecodingError.typeMismatch(let type, let context) {
            SwiftMoLogger.error("type mismatch for type \(type) in JSON: \(context.debugDescription)", tag: .parsing)
        } catch DecodingError.dataCorrupted(let context) {
            SwiftMoLogger.error("data found to be corrupted in JSON: \(context.debugDescription)", tag: .parsing)
        } catch let error as NSError {
            SwiftMoLogger.error("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)", tag: .parsing)
        } catch {
            SwiftMoLogger.error("Failed to Parse Object with this type: \(object)\nError: \(error)", tag: .parsing)
        }

        return nil
    }
}
