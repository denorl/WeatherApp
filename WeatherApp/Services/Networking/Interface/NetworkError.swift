//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 28/3/26.
//
import Foundation

enum NetworkError: Error {
    case badUrl
    case unauthorized
    case encodingError
    case decodingError(Error)
    case noInternet
    case invalidResponse(statusCode: Int)
    case requestFailed(Error)
    case unknown
    
    var isAuthError: Bool {
        if case .invalidResponse(let code) = self {
            return code == 401
        }
        return false
    }
}

// MARK: - LocalizedError Implementation
extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "Invalid URL: The URL components could not be resolved."
        case .unauthorized:
            return "Unauthorized: HTTP 401. The access token is invalid or expired."
        case .encodingError:
            return "Encoding Error: Could not serialize the request body into the specified format."
        case .decodingError(let error):
            return "Decoding Error: Failed to map JSON to the Model. \(error.localizedDescription)"
        case .noInternet:
            return "Network Error: NSURLErrorNotConnectedToInternet."
        case .invalidResponse(let statusCode):
            return "Server Error: Received an invalid HTTP status code: \(statusCode)."
        case .requestFailed(let error):
            return "Request Failed: \(error.localizedDescription)"
        case .unknown:
            return "Unknown Error: An undefined error occurred in the networking layer."
        }
    }
    
    var userMessage: String {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .noInternet:
            return "Please check your internet connection and try again."
        case .encodingError, .decodingError, .badUrl:
            return "We encountered a problem processing the data. Please contact support if this persists."
        case .invalidResponse(let statusCode) where statusCode >= 500:
            return "Our servers are currently down. We are working to fix this!"
        default:
            return "Something went wrong. Please try again later."
        }
    }
    
}

