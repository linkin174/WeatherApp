//
//  LocationService.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 29.01.2023.
//

import CoreLocation
import Foundation

protocol LocationServiceProtocol {
    func getLocation(completion: @escaping (CLLocation?) -> Void)
}

final class LocationService: NSObject, LocationServiceProtocol {
    // MARK: - Private properties

    private var locationManager: CLLocationManager?
    private var completion: ((CLLocation?) -> Void)?

    // MARK: - Initializers

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.distanceFilter = 10_000
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.showsBackgroundLocationIndicator = true
    }

    // MARK: - Public methods

    func getLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        locationManager?.startUpdatingLocation()
    }
}

// MARK: - Extensions

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        case .restricted, .denied:
            if let completion {
                completion(nil)
            }
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let completion {
            completion(locations.last)
        }
        locationManager?.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let completion {
            completion(nil)
        }
    }
}
