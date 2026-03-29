//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 27/3/26.
//

import Foundation
import CoreLocation

protocol WeatherPresenterProtocol {
    var view: WeatherViewProtocol? { get set }
    func viewDidLoad()
    func updateWeather()
}

@MainActor
final class WeatherPresenter: WeatherPresenterProtocol {
    weak var view: WeatherViewProtocol?
    
    let networkingManager: NetworkingManager
    let locationManager: LocationManager
        
    init(networkingManager: NetworkingManager, locationManager: LocationManager) {
        self.networkingManager = networkingManager
        self.locationManager = locationManager
    }
    
    func viewDidLoad() {
        locationManager.delegate = self
        locationManager.requestLocation()
        updateWeather()
    }
    
    func updateWeather() {
        view?.toggleActivityIndicator(on: true)
        Task {
            do {
                guard let coordinates = coordinatesFor(location: locationManager.location) else { return }
                let request = try OpenWeatherEndpoint.current(coordinates).asURLRequest()
                let weatherData: WeatherResponse = try await networkingManager.fetch(with: request)
                
                guard let icon = weatherData.weather.first?.icon else { return }
                
                let weatherIcon = WeatherTheme.weatherIcon(for: icon)
                let viewModel =  mapDataToViewModel(weatherData, icon: weatherIcon)
                
                view?.toggleActivityIndicator(on: false)
                view?.updateUI(with: viewModel)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - LocationManagerDelegate
extension WeatherPresenter: LocationManagerDelegate {
    func didFailWithError(_ error: any Error) {
        print(error.localizedDescription)
    }
}

//MARK: - Private methods
private extension WeatherPresenter {
    func coordinatesFor(location: CLLocation?) -> Coordinates? {
        guard let location = location else { return nil }
        let coordinates = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        return coordinates
    }
    
    func getWeatherImage(for icon: String) async throws -> Data {
        let imageRequest = try OpenWeatherEndpoint.weatherIcon(icon).asURLRequest()
        let imageData = try await networkingManager.fetchImage(with: imageRequest)
        
        return imageData
    }
    
    func mapDataToViewModel(_ weatherData: WeatherResponse, icon: WeatherIcon) -> WeatherViewModel {
        return WeatherViewModel(
            locality: weatherData.name,
            temperature: weatherData.main.temp.asTemperatureString(for: .metric),
            feelsLike: weatherData.main.feelsLike.asTemperatureString(for: .metric),
            humidity: weatherData.main.humidity.percentageString,
            pressure: weatherData.main.pressure.numberAsString,
            weatherIcon: icon)
    }
}
