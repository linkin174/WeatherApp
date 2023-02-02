//
//  CurrentWeather.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 14.01.2023.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable, Identifiable {

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
    var id: Int?
    let sys: Sys

    static let placeholder = CurrentWeather(coord: Coord(lon: 37.1923, lat: -122.032),
                                      weather: [Weather(id: 0, main: "Gust", description: "Windy", icon: "01d")],
                                      main: Main(temp: 10,
                                                 feelsLike: 20,
                                                 tempMin: 3,
                                                 tempMax: 15,
                                                 pressure: 1040,
                                                 seaLevel: 120,
                                                 grndLevel: 0,
                                                 humidity: 75),
                                      visibility: 10000,
                                      wind: Wind(speed: 10, deg: 360, gust: 15),
                                      rain: nil,
                                      snow: nil,
                                      clouds: nil,
                                      dt: 10002030,
                                      timezone: 123413451,
                                      name: "Cupertino",
                                      id: 0,
                                      sys: Sys(sunrise: 1010, sunset: 1010))
}

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}
