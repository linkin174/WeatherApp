//
//  DetailsInteractor.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 10.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailsBusinessLogic {
    func loadForecast()
}

protocol DetailsDataStore {
    var weather: CurrentWeather? { get set }
}

class DetailsInteractor: DetailsBusinessLogic, DetailsDataStore {

    // MARK: - Public Properties

    var weather: CurrentWeather?
    var presenter: DetailsPresentationLogic?

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol

    // MARK: - Initializers

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: Interaction Logic

    func loadForecast() {
        guard let weather else { return }
        // For displaying header
        let response = Details.ShowCurrentWeather.Response(weather: weather)
        presenter?.presentCurrentWeather(response: response)
        // Loading daily information
        let city = City(coord: weather.coord, id: weather.internalId ?? 0)
        networkService.fetchDailyForecast(for: city) { [unowned self] result in
            switch result {
            case .success(let forecast):
                let response = Details.ShowForecast.Response(forecast: forecast, currentweather: weather)
                presenter?.presentForecast(response: response)
            case .failure(let error):
                let response = Details.HandleError.Response(error: error)
                presenter?.presentError(response: response)
            }
        }
    }
}
