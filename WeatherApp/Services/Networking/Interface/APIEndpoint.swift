//
//  APIEndpoint.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 26/3/26.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIEndpoint {
    var baseUrl: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String : String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: HTTPBody? { get }
    
    var encoder: JSONEncoder { get }
}

//MARK: - Default implementation
extension APIEndpoint {
    var httpMethod: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: HTTPBody? { nil }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(url: baseUrl.appending(path: path), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            switch body {
            case .json(let json):
                do {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try encoder.encode(json)
                } catch {
                    throw NetworkError.encodingError
                }
            case .plainText(let text):
                request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                request.httpBody = text.data(using: .utf8)
            case .raw(let data, let contentType):
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = data
            }
        }
        
        return request
    }
}
