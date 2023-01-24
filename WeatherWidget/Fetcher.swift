//
//  Fetcher.swift
//  WeatherWidgetExtension
//
//  Created by Aleksandr Kretov on 24.01.2023.
//

import Alamofire
import Foundation

enum FetcherError: Error {
    case noConnection
    case badResponse
    case noData
    case badDecoding
}

extension FetcherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return NSLocalizedString("No connection to the internet", comment: "")
        case .badResponse:
            return NSLocalizedString("Server not responding", comment: "")
        case .noData:
            return NSLocalizedString("No data was retrived from server", comment: "")
        case .badDecoding:
            return NSLocalizedString("Data can't be decoded", comment: "")
        }
    }
}

protocol WeatherFetchingProtocol {
    func fetchCurrentWeather() async -> [CurrentWeather]
}

final class FetcherService: WeatherFetchingProtocol {
    // MARK: - Private Properties

    private let userDefaults = UserDefaults(suiteName: "group.xxxZZZCCC")
    private var cities: [City] = []
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init() {
        cities = loadCities()
    }

    func fetchCurrentWeather() async -> [CurrentWeather] {
        var out = [CurrentWeather]()
            for city in cities {
                let parameters = makeParameters(for: city)
                guard let url = createURL(method: WeatherAPI.getWeather, parameters: parameters) else { return [] }
                let request = URLRequest(url: url)
                guard let data = try? await URLSession.shared.data(for: request) else { return [] }
                guard var decoded = try? decoder.decode(CurrentWeather.self, from: data.0) else { return [] }
                decoded.id = city.id
                out.append(decoded)
            }
        return out
    }

    private func loadCities() -> [City] {
        guard
            let data = userDefaults?.data(forKey: "cities"),
            let cities = try? JSONDecoder().decode([City].self, from: data)
        else { return [] }
        print("\(cities)")
        return cities
    }

    private func createURL(method: String, parameters: [String: String]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = WeatherAPI.scheme
        components.host = WeatherAPI.host
        components.path = method
        if let parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        }
        return components.url
    }

    private func makeParameters(for city: City) -> [String: String] {
        var parameters = [String: String]()
        #warning("remove hardcoded key")
//        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else { return parameters }
        parameters["appid"] = "05dfd9d22876bb2df80d839573cf47e2"
        parameters["units"] = "metric"
        if let longitude = city.coord?.lon, let latitude = city.coord?.lat {
            parameters["lon"] = String(longitude)
            parameters["lat"] = String(latitude)
        }
        return parameters
    }
}
