//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 25/3/26.
//
import Foundation

final class OpenWeatherManager: NetworkingManager {
    private let interceptor: RequestInterceptor?
    
    init(interceptor: RequestInterceptor? = nil) {
        self.interceptor = interceptor
    }
    
    func fetch<T: Codable>(with request: URLRequest) async throws -> T {
        let finalRequest = try interceptor?.adapt(request) ?? request
        let data = try await performRequest(finalRequest)
       
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchImage(with request: URLRequest) async throws -> Data {
        return try await performRequest(request)
    }
}

//MARK: - Private methods
private extension OpenWeatherManager {
    func performRequest(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
        
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
            }
            
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                throw NetworkError.noInternet
            }
            
            throw NetworkError.requestFailed(error)
        }
    }
}
