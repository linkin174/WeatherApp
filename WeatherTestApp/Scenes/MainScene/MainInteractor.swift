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
    var currentWeather: [DailyForecast] { get }
    var filteredWeather: [DailyForecast] { get }
}

class MainInteractor: NSObject, MainBusinessLogic, MainDataStore {
    // MARK: Public Properties

    var presenter: MainPresentationLogic?
    var currentWeather: [DailyForecast] = []
    var filteredWeather: [DailyForecast] = []
    private var places: [PlaceElement] = []

    // MARK: Private properties

    private let storageService: StorageServiceProtocol
    private let networkService: NetworkServiceProtocol
    private var locationManager: CLLocationManager?
    private var cities: [City] = []

    // MARK: Initializers

    init(storageService: StorageServiceProtocol, networkService: NetworkServiceProtocol) {
        self.storageService = storageService
        self.networkService = networkService
        super.init()
        cities = storageService.loadCities()
    }

    // MARK: Interaction Logic

    func loadData() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func searchCity(request: MainScene.SearchCities.Request) {
        if request.isSearching {
            filteredWeather = currentWeather.filter { daily in
                if let name = daily.city.name {
                    return name.lowercased().contains(request.searchString.lowercased())
                }
                return false
            }

            networkService.fetchCities(searchString: request.searchString) { [unowned self] knownPlaces in
                    places = knownPlaces
                let response = MainScene.SearchCities.Response(filteredForecast: filteredWeather, places: places)
                presenter?.presentSearchResults(response: response)
//                    let response = MainScene.LoadWeather.Response(weather: filteredWeather, knownCities: places)
//                    presenter?.presentWeather(response: response)

            }
        } else {
            places.removeAll()
            let response = MainScene.LoadWeather.Response(weather: currentWeather, knownCities: places)
            presenter?.presentWeather(response: response)
        }
    }

    func addCity(request: MainScene.AddCity.Request) {
        let placeToAdd = places[request.indexPath.row]
        let city = City(name: placeToAdd.name,
                        coord: Coord(lon: placeToAdd.lon, lat: placeToAdd.lat), id: currentWeather.count)
        storageService.add(city)
        cities.append(city)
        networkService.fetchDailyForecast(for: [city]) { [unowned self] result in
            switch result {
            case .success(let forecast):
                if let first = forecast.first {
                    currentWeather.append(first)
                    places.removeAll()
                    let response = MainScene.LoadWeather.Response(weather: currentWeather, knownCities: places)
                    presenter?.presentWeather(response: response)
                }
            case .failure(let error):
                let response = MainScene.HandleError.Response(error: error)
                presenter?.presentError(response: response)
            }
        }
    }

    func removeCity(request: MainScene.RemoveCity.Request) {
        guard let city = cities.first(where: { $0.id == request.cityID }) else { return }
        currentWeather.removeAll(where: { $0.city.id == city.id })
        storageService.remove(city)
    }

    // MARK: Private Methods

    private func loadForecast() {
        updateCitiesWithLocaitonInfo()
        networkService.fetchDailyForecast(for: cities) { [unowned self] result in
            switch result {
            case .success(let success):
                self.currentWeather = success
                    .sorted { $0.city.id ?? 0 < $1.city.id ?? 0 }
                let response = MainScene.LoadWeather.Response(weather: currentWeather, knownCities: places)
                self.presenter?.presentWeather(response: response)
            case .failure(let error):
                let response = MainScene.HandleError.Response(error: error)
                self.presenter?.presentError(response: response)
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
}

extension MainInteractor: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default: loadForecast()
        }
    }
}
