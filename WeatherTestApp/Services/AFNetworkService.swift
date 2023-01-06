//
//  AFNetworkService.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 07.12.2022.
//

import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func fetchDailyForecast(for cities: [City], completion: @escaping (Result<[DailyForecast], AFError>) -> Void)
    func fetchCities(searchString: String, completion: @escaping ([PlaceElement]) -> Void)
}

private enum API {
    case weather, geocoder
}

final class AFNetworkService: NetworkServiceProtocol {
    // MARK: Public Methods

    func fetchDailyForecast(for cities: [City], completion: @escaping (Result<[DailyForecast], Alamofire.AFError>) -> Void) {
        let group = DispatchGroup()
        let url = createURL(api: .weather, WeatherAPI.getForecast)
        var output: [DailyForecast] = []
        var fetchingError: AFError?

        for city in cities {
            group.enter()
            let parameters = makeParameters(for: city)
            AF.request(url, parameters: parameters)
                .validate()
                .responseDecodable(of: DailyForecast.self) { response in
                    switch response.result {
                    case .success(var currentWeather):
                        currentWeather.city.id = city.id
                        output.append(currentWeather)
                        group.leave()
                    case .failure(let error):
                        fetchingError = error
                        group.leave()
                    }
                }
        }

        group.notify(queue: .main) {
            completion(.success(output))
            if let fetchingError {
                completion(.failure(fetchingError))
            }
        }
    }

    func fetchCities(searchString: String, completion: @escaping ([PlaceElement]) -> Void) {
        let url = createURL(api:.geocoder, GeocoderAPI.searchCity)
        let parameters = makeParameters(for: searchString)
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: [PlaceElement].self) { response in
                switch response.result {
                case .success(let searchedCities):
                    completion(searchedCities)
                default: break
                }
            }
    }

    // MARK: Private methods

    private func makeParameters(for city: City) -> [String: String] {
        var parameters = [String: String]()
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else { return parameters }
        parameters["appid"] = key
        parameters["units"] = "metric"
        if let longitude = city.coord?.lon, let latitude = city.coord?.lat {
            parameters["lon"] = String(longitude)
            parameters["lat"] = String(latitude)
        }
        return parameters
    }

    private func makeParameters(for searchString: String) -> [String: String] {
        var parameters = [String: String]()
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else { return parameters }
        parameters["appid"] = key
        parameters["q"] = searchString
        parameters["limit"] = "10"
        return parameters
    }

    private func createURL(api: API, _ method: String) -> String {
        var components = URLComponents()
        switch api {
        case .weather:
            components.scheme = WeatherAPI.scheme
            components.host = WeatherAPI.host
        case .geocoder:
            components.scheme = GeocoderAPI.scheme
            components.host = GeocoderAPI.host
        }
        components.path = method
        return components.url?.absoluteString ?? ""
    }
}
