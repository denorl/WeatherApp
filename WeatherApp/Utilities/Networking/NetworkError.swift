//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 28/3/26.
//
import Foundation

enum NetworkError: LocalizedError {
    case badUrl
    case requestFailed(Error)
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case noInternet
    case unknown

    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "The URL provided was invalid."
        case .requestFailed:
            return "Network request failed"
        case .invalidResponse(let code):
            return "Server returned an invalid response (Status: \(code))."
        case .decodingError(let error):
            return "Failed to parse the weather data. \(error.localizedDescription)"
        case .noInternet:
            return "No internet connection detected."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
    
    var isAuthError: Bool {
        if case .invalidResponse(let code) = self {
            return code == 401
        }
        return false
    }
}
