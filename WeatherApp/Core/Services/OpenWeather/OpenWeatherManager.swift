//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 25/3/26.
//
import Foundation

final class OpenWeatherManager: NetworkingManager {
    var interceptor: RequestInterceptor?
    
    init(interceptor: RequestInterceptor? = nil) {
        self.interceptor = interceptor
    }
}
