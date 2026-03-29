//
//  Untitled.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 27/3/26.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didFailWithError(_ error: Error)
}

final class LocationManager: NSObject {
    private let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    var location: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error)
    }
}
