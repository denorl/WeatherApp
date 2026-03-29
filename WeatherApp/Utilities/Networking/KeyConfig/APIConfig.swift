//
//  APIConfig.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 26/3/26.
//
import Foundation

enum APIConfig {
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY is missing from Info.plist or xcconfig")
        }
        return key
    }
}

