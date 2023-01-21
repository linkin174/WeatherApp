//
//  MainInteractor.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 06.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import CoreLocation
import UIKit

protocol MainBusinessLogic: AnyObject {
    func loadData()
    func searchCity(request: MainScene.SearchCities.Request)
    func removeCity(request: MainScene.RemoveCity.Request)
    func addCity(request: MainScene.AddCity.Request)
}

protocol MainDataStore {
    var currentWeather: [CurrentWeather] { get }
    var filteredWeather: [CurrentWeather] { get }
}

final class MainInteractor: NSObject, MainBusinessLogic, MainDataStore {
    
    // MARK: - Public Properties

    var presenter: MainPresentationLogic?
    var currentWeather: [CurrentWeather] = []
    var filteredWeather: [CurrentWeather] = []
    private var places: [Place] = []

    // MARK: - Private properties

    private let storageService: StorageServiceProtocol
    private let networkService: NetworkServiceProtocol
    private var locationManager: CLLocationManager?
    private var cities: [City] = []

    // MARK: - Initializers

    init(storageService: StorageServiceProtocol, networkService: NetworkServiceProtocol) {
        self.storageService = storageService
        self.networkService = networkService
    }

    // MARK: - Interaction Logic

    func loadData() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        cities = storageService.loadCities()
    }

    func searchCity(request: MainScene.SearchCities.Request) {
        if request.isSearching {
            filteredWeather = currentWeather.filter { weather in
                if let cityName = weather.name {
                    return cityName.lowercased().contains(request.searchString.lowercased())
                }
                return false
            }
            networkService.fetchCities(searchString: request.searchString) { [unowned self] knownPlaces in
                places = knownPlaces.filter { element in
                    let coord = Coord(lon: element.lon, lat: element.lat)
                    return !currentWeather.contains(where: { roundCoordinates($0.coord) == roundCoordinates(coord) })
                }
                let response = MainScene.LoadWeather.Response(weather: filteredWeather, places: places)
                presenter?.presentWeather(response: response)
            }
        } else {
            places.removeAll()
            let response = MainScene.LoadWeather.Response(weather: currentWeather, places: places)
            presenter?.presentWeather(response: response)
        }
    }

    func addCity(request: MainScene.AddCity.Request) {
        let placeToAdd = places[request.indexPath.row]
        let city = City(name: placeToAdd.name,
                        coord: Coord(lon: placeToAdd.lon, lat: placeToAdd.lat), id: currentWeather.count + 1)
        storageService.add(city)
        cities.append(city)
        networkService.fetchCurrentWeather(for: [city]) { [unowned self] result in
            switch result {
            case .success(let weather):
                guard let first = weather.first else { return }
                currentWeather.append(first)
                places.removeAll()
                let response = MainScene.LoadWeather.Response(weather: currentWeather, places: places)
                presenter?.presentWeather(response: response)
            case .failure(let error):
                let respone = MainScene.HandleError.Response(error: error)
                presenter?.presentError(response: respone)
            }
        }
    }

    func removeCity(request: MainScene.RemoveCity.Request) {
        guard let city = cities.first(where: { $0.id == request.cityID }) else { return }
        currentWeather.removeAll(where: { $0.internalId == city.id })
        storageService.remove(city)
    }

    // MARK: - Private Methods

    private func loadForecast() {
        updateCitiesWithLocaitonInfo()
        networkService.fetchCurrentWeather(for: cities) { [unowned self] result in
            switch result {
            case .success(let weather):
                self.currentWeather = weather
                    .sorted { $0.internalId ?? 0 < $1.internalId ?? 0}
                let response = MainScene.LoadWeather.Response(weather: currentWeather, places: places)
                presenter?.presentWeather(response: response)
            case .failure(let error):
                let response = MainScene.HandleError.Response(error: error)
                presenter?.presentError(response: response)
            }
        }
    }

    private func updateCitiesWithLocaitonInfo() {
        if let location = locationManager?.location {
            let currentCity = City(coord: Coord(lon: location.coordinate.longitude,
                                                lat: location.coordinate.latitude),
                                   id: 0)
            if let index = cities.firstIndex(where: { $0.id == currentCity.id }) {
                cities[index] = currentCity
            } else {
                cities.insert(currentCity, at: 0)
            }
        }
    }

    private func roundCoordinates(_ coord: Coord?) -> Coord? {
        guard let lat = coord?.lat, let lon = coord?.lon else { return nil }
        let roundedLon = round(lon * 100) / 100
        let roundedLat = round(lat * 100) / 100
        return Coord(lon: roundedLon, lat: roundedLat)
    }
}
// MARK: - Extensions
extension MainInteractor: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default: loadForecast()
        }
    }
}
