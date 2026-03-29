//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 25/3/26.
//
import Foundation

final class OpenWeatherManager: NetworkingManager {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let interceptor: RequestInterceptor?
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder(), interceptor: RequestInterceptor? = nil) {
        self.session = session
        self.decoder = decoder
        self.interceptor = interceptor
    }
    
    func fetch<T: Codable>(with request: URLRequest) async throws -> T {
        let finalRequest = try interceptor?.adapt(request) ?? request
        let data = try await performRequest(finalRequest)
        
        do {
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
            let (data, response) = try await session.data(for: request)
            
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
