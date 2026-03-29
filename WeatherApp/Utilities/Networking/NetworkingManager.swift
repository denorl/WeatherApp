//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 27/3/26.
//
import Foundation

protocol NetworkingManager {
    var interceptor: RequestInterceptor? { get }
    func fetch<T: Codable>(with request: URLRequest) async throws -> T
    func fetchImage(with request: URLRequest) async throws -> Data
}

extension NetworkingManager {
    private func performRequest(_ request: URLRequest) async throws -> Data {
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
    
    func fetch<T: Codable>(with request: URLRequest) async throws -> T {
        let finalRequest = interceptor?.adapt(request) ?? request
        print(finalRequest.url)
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
