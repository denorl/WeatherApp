//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 26/3/26.
//

import UIKit

import Foundation

struct WeatherResponse: Codable {
    let weather: [WeatherCondition]
    let main: MainData
    let name: String
}

struct MainData: Codable {
    let temp: Double
    let feelsLike: Double
    let humidity: Double
    let pressure: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
        case pressure
    }
}

struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
