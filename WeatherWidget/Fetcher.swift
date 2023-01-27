//
//  Fetcher.swift
//  WeatherWidgetExtension
//
//  Created by Aleksandr Kretov on 24.01.2023.
//

import Alamofire
import Foundation

enum FetcherError: Error {
    case badURL
    case noConnection
    case badResponse
    case noData
    case badDecoding
    case noCities
}

extension FetcherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("Bad url for request", comment: "")
        case .noConnection:
            return NSLocalizedString("No connection to the internet", comment: "")
        case .badResponse:
            return NSLocalizedString("Server not responding", comment: "")
        case .noData:
            return NSLocalizedString("No data was retrived from server", comment: "")
        case .badDecoding:
            return NSLocalizedString("Data can't be decoded", comment: "")
        case .noCities:
            return NSLocalizedString("No cities stored in list", comment: "")
        }
    }
}

protocol WeatherFetchingProtocol {
    func fetchCurrentWeather() async throws -> CurrentWeather
}

final class FetcherService: WeatherFetchingProtocol {
    // MARK: - Private Properties

    private let userDefaults = UserDefaults(suiteName: "group.xxxZZZCCC")
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func fetchCurrentWeather() async throws -> CurrentWeather {
        guard let city = loadCity() else { throw FetcherError.noCities }
        let parameters = makeParameters(for: city)
        guard let url = createURL(method: WeatherAPI.getWeather, parameters: parameters) else { throw FetcherError.badURL }
        let request = URLRequest(url: url)
        guard let data = try? await URLSession.shared.data(for: request) else { throw FetcherError.noData }
        guard var decoded = try? decoder.decode(CurrentWeather.self, from: data.0) else { throw FetcherError.badDecoding }
        decoded.id = city.id
        return decoded
    }

    private func loadCity() -> City? {
        guard
            let data = userDefaults?.data(forKey: "cities"),
            let cities = try? JSONDecoder().decode([City].self, from: data),
            let first = cities.first
        else { return nil }
        print("First city \(first)")
        return first
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
