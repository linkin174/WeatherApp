//
//  WidgetFetcherService.swift
//  WeatherWidgetExtension
//
//  Created by Aleksandr Kretov on 24.01.2023.
//

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
    func fetchCurrentWeather(for city: City) async throws -> CurrentWeather
}

final class WidgetFetcherService: WeatherFetchingProtocol {
    // MARK: - Private Properties

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func fetchCurrentWeather(for city: City) async throws -> CurrentWeather {
        let parameters = makeParameters(for: city)
        guard let url = createURL(method: WeatherAPI.getWeather, parameters: parameters) else { throw FetcherError.badURL }
        let request = URLRequest(url: url)
        guard let data = try? await URLSession.shared.data(for: request) else { throw FetcherError.noData }
        guard var decoded = try? decoder.decode(CurrentWeather.self, from: data.0) else { throw FetcherError.badDecoding }
        decoded.id = city.id
        return decoded
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
        guard
            let mainBundle = Bundle(url: Bundle.main.bundleURL.deletingLastPathComponent().deletingLastPathComponent()),
            let key = mainBundle.infoDictionary?["API_KEY"] as? String
        else {
            return parameters
        }
        parameters["appid"] = key
        parameters["units"] = "metric"
        if let longitude = city.coord?.lon, let latitude = city.coord?.lat {
            parameters["lon"] = String(longitude)
            parameters["lat"] = String(latitude)
        } else if let name = city.name {
            parameters["q"] = name
        }
        return parameters
    }
}
