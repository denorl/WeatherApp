//
//  WeatherIconMapper.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 28/3/26.
//
import UIKit

typealias WeatherIcon = (name: String, tintColor: UIColor)

enum WeatherTheme {
    static func weatherIcon(for iconCode: String) -> WeatherIcon {
        switch iconCode {
        case "01d":
            return ("sun.max.fill", .systemYellow)
        case "01n":
            return ("moon.stars.fill", .systemIndigo)
        case "02d":
            return ("cloud.sun.fill", .systemOrange)
        case "02n":
            return ("cloud.moon.fill", .systemGray2)
        case "03d", "03n", "04d", "04n":
            return ("cloud.fill", .systemGray)
        case "09d", "09n", "10d", "10n":
            return ("cloud.rain.fill", .systemBlue)
        case "11d", "11n":
            return ("cloud.bolt.rain.fill", .systemPurple)
        case "13d", "13n":
            return ("snowflake", .systemCyan)
        case "50d", "50n": 
            return ("cloud.fog.fill", .systemTeal)
        default:
            return ("questionmark.circle", .systemGray)
        }
    }
}
