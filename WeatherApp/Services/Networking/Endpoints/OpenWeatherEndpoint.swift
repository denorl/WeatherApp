//
//  OpenWeatherEndpoint.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 26/3/26.
//
import Foundation

enum OpenWeatherEndpoint: APIEndpoint {
    case current(Coordinates)
    case weatherIcon(String)
    
    var baseUrl: URL {
        switch self {
        case .current:
            URL(string: "https://api.openweathermap.org")!
        case .weatherIcon:
            URL(string: "https://openweathermap.org")!
        }
    }
    
    var path: String {
        switch self {
        case .current: 
            "/data/2.5/weather"
        case .weatherIcon(let iconName):
            "/img/wn/\(iconName)@2x.png"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .current: HTTPMethod.get
        case .weatherIcon: HTTPMethod.get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .current(let coordinates):
            return [
                URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinates.longitude)"),
                URLQueryItem(name: "units", value: "metric")
            ]
            
        default: return nil
        }
    }
}
