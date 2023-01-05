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

    // MARK: LoadWeather UseCase

    enum LoadWeather {
        struct Response {
            let weather: [DailyForecast]
            let knownCities: [CityElement]
        }

        struct ViewModel {
            var weatherCellViewModels: [WeatherCellViewModelProtocol]
            var cityCellViewModels: [CityCellViewModelProtocol]
        }
    }

    // MARK: SearchForCities UseCase

    enum SearchCities {
        struct Request {
            let searchString: String
            let isSearching: Bool
        }
    }

    // MARK: RemoveCityUseCase

    enum RemoveCity {
        struct Request {
            let cityID: Int
        }

        #warning("display search results??")
    }

    // MARK: AddCity UseCase

    enum AddCity {

        struct Request {
            let city: City
        }

        struct Response {
            let cityForecast: DailyForecast
        }

        struct ViewModel {
            let cellViewModel: WeatherCellViewModelProtocol
        }
    }

    // MARK: HandleError UseCase

    enum HandleError {
        struct Response {
            let error: Error
        }

        struct ViewModel {
            let errorMessage: String
        }
    }
}

// MARK: ViewModels

struct WeatherCellViewModel: WeatherCellViewModelProtocol {
    let cityName: String
    let weatherIcon: UIImage?
    let temp: String
    let currentTime: String
    let cityId: Int
}

struct CityCellViewModel: CityCellViewModelProtocol {
    let cityName: String
    let stateName: String
    let countryName: String
    let latitude: Double
    let longitude: Double
}
