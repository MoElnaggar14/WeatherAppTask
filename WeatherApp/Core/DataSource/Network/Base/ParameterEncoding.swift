//
//  ParameterEncoding.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

public enum ParameterEncoding {
    /// Encodes the parameters as url query parameters
    case urlEncoding
    /// Encodes the parameters in the body of the request
    case jsonEncoding
    /// Encodes the parameters as a multipart form data and file data
    case multipartEncoding
    /// This data is sent as the message body of the request, as
    case httpBody
}
