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

import UIKit

// MARK: - Interactor Interface

protocol MainBusinessLogic: AnyObject {
    func loadData(force: Bool)
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
    private var locationService: LocationServiceProtocol

    // MARK: - Initializers

    init(storageService: StorageServiceProtocol, networkService: NetworkServiceProtocol, locationService: LocationServiceProtocol) {
        self.storageService = storageService
        self.networkService = networkService
        self.locationService = locationService
        super.init()
        loadData(force: true)
    }

    // MARK: - Interaction Logic

    func loadData(force: Bool) {
        if force {
            handleCurrentLocationAndLoad()
        } else {
            let currentDate = Date()
            let forecastDate = Date().dateFrom(secondsUTC: currentWeather.first?.dt ?? 0)
            if forecastDate.distance(to: currentDate) > 3600 {
                handleCurrentLocationAndLoad()
            } else {
                presenter?.endLoading()
            }
        }
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
        let currentCities = storageService.getCities()
        let maxID = currentCities.max(by: { $1.id ?? 0 > $0.id ?? 0 })?.id ?? 0
        let city = City(name: placeToAdd.name,
                        coord: Coord(lon: placeToAdd.lon, lat: placeToAdd.lat),
                        id: maxID + 1)
        storageService.save(city)
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
        let cities = storageService.getCities()
        guard let cityID = cities.first(where: { $0.id == request.cityID })?.id else { return }
        currentWeather.removeAll(where: { $0.id == cityID })
        storageService.remove(cityID: cityID)
    }

    // MARK: - Private Methods

    private func handleCurrentLocationAndLoad() {
        locationService.getLocation { [unowned self] location in
            if let location {
                let currentCity = City(coord: Coord(lon: location.coordinate.longitude,
                                                    lat: location.coordinate.latitude),
                                       id: 0)
                storageService.save(currentCity)
            } else {
                storageService.remove(cityID: 0)
            }
            loadForecast()
        }
    }

    private func loadForecast() {
        let cities = storageService.getCities()
        networkService.fetchCurrentWeather(for: cities) { [unowned self] result in
            switch result {
            case .success(let weather):
                self.currentWeather = weather
                    .sorted { $0.id ?? 0 < $1.id ?? 0 }
                let response = MainScene.LoadWeather.Response(weather: currentWeather, places: places)
                presenter?.presentWeather(response: response)
            case .failure(let error):
                let response = MainScene.HandleError.Response(error: error)
                presenter?.presentError(response: response)
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
