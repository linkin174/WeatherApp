//
//  LocationService.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 05.01.2023.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func getCurrentCoordinates(completion: @escaping (Coord?) -> Void)
}

final class LocationService: NSObject, LocationServiceProtocol {

    // MARK: - Private Properties

    private let locationManager = CLLocationManager()


    // MARK: - Initializers

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    // MARK: Public Methods

    func getCurrentCoordinates(completion: @escaping (Coord?) -> Void) {
        guard
            let latitude = locationManager.location?.coordinate.latitude.magnitude,
            let longitude = locationManager.location?.coordinate.longitude.magnitude
        else {
            completion(nil)
            return
        }
        completion(Coord(lon: longitude, lat: latitude))
    }
}

// MARK: - Extensions

extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}

}
