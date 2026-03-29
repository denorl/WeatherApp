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
}

extension APIEndpoint {
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(url: baseUrl.appending(path: path), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
