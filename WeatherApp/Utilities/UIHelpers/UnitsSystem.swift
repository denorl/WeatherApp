//
//  UnitsSystem.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 27/3/26.
//

import Foundation

enum UnitsSystem: String, CaseIterable, Codable {
    case metric
    case imperial
    
    var tempSymbol: String {
        switch self {
        case .metric: return "°C"
        case .imperial: return "°F"
        }
    }
    
    var speedSymbol: String {
        switch self {
        case .metric: return "m/s"
        case .imperial: return "mph"
        }
    }
}
