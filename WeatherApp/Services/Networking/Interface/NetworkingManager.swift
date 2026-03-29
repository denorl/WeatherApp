//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 27/3/26.
//
import Foundation

protocol NetworkingManager {
    func fetch<T: Codable>(with request: URLRequest) async throws -> T
    func fetchImage(with request: URLRequest) async throws -> Data
}
