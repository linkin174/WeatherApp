//
//  Forecast.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 07.12.2022.
//

import Foundation

// MARK: - DailyForecast

struct DailyForecast: Codable {
    let list: [Hourly]
    var city: City
}

// MARK: - List

struct Hourly: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let snow: Snow?
    let dtTxt: String
}

// MARK: - Main

struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int?
}

// MARK: - Rain

struct Rain: Codable {
    let threeHours: Double?
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Snow: Codable {
    let threeHours: Double?
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

// MARK: - Wind

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

// MARK: - Clouds

struct Clouds: Codable {
    let all: Int?
}
