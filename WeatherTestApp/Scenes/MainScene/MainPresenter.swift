//
//  MainPresenter.swift
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

protocol MainPresentationLogic {
    func presentWeather(response: MainScene.LoadWeather.Response)
    func presentError(response: MainScene.HandleError.Response)
//    func presentNewCity(response: MainScene.AddCity.Response)
}

class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?

    func presentWeather(response: MainScene.LoadWeather.Response) {
        let cellsViewModels = response.weather.map { daily in
            let icon = UIImage(named: String(daily.list.first?.weather.first?.icon?.dropLast() ?? ""))
            return WeatherCellViewModel(cityName: daily.city.name ?? "noname",
                                        weatherIcon: icon,
                                        temp: getFormattedTemp(daily.list.first?.main.temp ?? 0),
                                        currentTime: formatGMTDate(from: daily.city.timezone ?? 0),
                                        cityId: daily.city.id ?? 0)
        }

        let cityCellViewModels = response.knownCities
            .reduce(into: [CityCellViewModelProtocol]()) { partialResult, element in
                if !response.weather.contains(where: { $0.city.country == element.country && $0.city.name == element.name }) {
                    partialResult.append(CityCellViewModel(cityName: element.name,
                                                           stateName: element.state ?? "",
                                                           countryName: getCountryName(from: element.country),
                                                           latitude: element.lat,
                                                           longitude: element.lon))
                }
            }
        let viewModel = MainScene.LoadWeather.ViewModel(weatherCellViewModels: cellsViewModels,
                                                        cityCellViewModels: cityCellViewModels)
        viewController?.displayCurrentWeather(viewModel: viewModel)
    }

    func presentError(response: MainScene.HandleError.Response) {
        let messege = response.error.asAFError?.localizedDescription
        let viewModel = MainScene.HandleError.ViewModel(errorMessage: messege ?? "")
        viewController?.displayError(viewModel: viewModel)
    }

//    func presentNewCity(response: MainScene.AddCity.Response) {
//        let icon = UIImage(named: String(response.cityForecast.list.first?.weather.first?.icon?.dropLast() ?? ""))
//        let cellViewModel = WeatherCellViewModel(cityName: response.cityForecast.city.name ?? "noname",
//                                                 weatherIcon: icon,
//                                                 temp: getFormattedTemp(response.cityForecast.list.first?.main.temp ?? 0),
//                                                 currentTime: formatGMTDate(from: response.cityForecast.city.timezone ?? 0),
//                                                 cityId: response.cityForecast.city.id ?? 0)
//        let viewModel = MainScene.AddCity.ViewModel(cellViewModel: cellViewModel)
//        viewController?.displayNewCity(viewModel: viewModel)
//    }
    private func getCountryName(from countryCode: String) -> String {
        let currentLocale = Locale.current
        return currentLocale.localizedString(forRegionCode: countryCode) ?? countryCode
    }

    private func getWeatherIcon(from code: String?) -> UIImage? {
        guard
            let codePrefix = code?.prefix(2),
            let image = UIImage(named: String(codePrefix))
        else { return nil }
        return image
    }

    private func formatGMTDate(from seconds: Int) -> String {
        let date = Date()
        let timeZone = TimeZone(secondsFromGMT: seconds)
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func getFormattedTemp(_ temp: Double) -> String {
        if round(temp) == 0 {
            // If temp is Zero ignore "-" sign and return 0
            return NSString(format: "0%@" as NSString, "\u{00B0}") as String
        } else {
            let roundedTemp = String(format: "%.f", temp)
            return NSString(format: "\(roundedTemp)%@" as NSString, "\u{00B0}") as String
        }
    }
}
