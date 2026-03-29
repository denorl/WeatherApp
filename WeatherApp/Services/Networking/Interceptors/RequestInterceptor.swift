//
//  RequestInterceptor.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 26/3/26.
//
import Foundation

protocol RequestInterceptor: Sendable {
    func adapt(_ request: URLRequest) throws -> URLRequest
}

struct OpenWeatherAuthInterceptor: RequestInterceptor {
    func adapt(_ request: URLRequest) throws -> URLRequest {
        guard let url = request.url else { return request }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let apiKey = APIConfig.apiKey
        
        guard !apiKey.isEmpty else { throw NetworkError.unauthorized }
        
        var queryItems = components?.queryItems ?? []
        queryItems.insert(URLQueryItem(name: "appid", value: apiKey), at: 0)
        components?.queryItems = queryItems
        
        var authenticatedRequest = request
        authenticatedRequest.url = components?.url
        
        return authenticatedRequest
    }
}

