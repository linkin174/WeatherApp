//
//  CurrentWeather.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 14.01.2023.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds?
    let dt: Int
    let timezone: Int
    let name: String?
    var internalId: Int?
    let sys: Sys
}

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}
