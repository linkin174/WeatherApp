//
//  MainModels.swift
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

// MARK: Use cases

struct MainScene {

    // MARK: - LoadWeather UseCase

    enum LoadWeather {

        struct Response {
            let weather: [CurrentWeather]
            let places: [PlaceElement]
        }

        struct ViewModel {
            var weatherCellViewModels: [WeatherCellViewModelProtocol]
            var placeCellViewModels: [PlaceCellViewModelRepresentable]
        }
    }

    // MARK: - SearchForCities UseCase

    enum SearchCities {
        struct Request {
            let searchString: String
            let isSearching: Bool
        }

        struct Response {
            let filteredForecast: [CurrentWeather]
            let places: [PlaceElement]
        }
    }

    // MARK: - RemoveCityUseCase

    enum RemoveCity {
        struct Request {
            let cityID: Int
        }
    }

    // MARK: - AddCity UseCase

    enum AddCity {

        struct Request {
            let indexPath: IndexPath
        }

        struct Response {
            let cityForecast: [CurrentWeather]
        }
    }

    // MARK: - HandleError UseCase

    enum HandleError {
        struct Response {
            let error: Error
        }

        struct ViewModel {
            let errorMessage: String
        }
    }
}

// MARK: - ViewModels

struct WeatherCellViewModel: WeatherCellViewModelProtocol {
    let cityName: String
    let weatherIcon: UIImage?
    let temp: String
    let currentTime: String
    let cityId: Int
}

struct PlaceCellViewModel: PlaceCellViewModelRepresentable {
    var cityName: String
    var stateName: String?
    var countryName: String
}
