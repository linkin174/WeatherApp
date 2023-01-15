//
//  City.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 06.12.2022.
//

import Foundation

struct City: Codable, Identifiable, Equatable {
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
    var id: Int?

    init(name: String? = nil, coord: Coord? = nil, country: String? = nil, population: Int? = nil,
         timezone: Int? = nil, sunrise: Int? = nil, sunset: Int? = nil, id: Int) {
        self.name = name
        self.coord = coord
        self.country = country
        self.population = population
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
        self.id = id
    }
}

// MARK: - Coord
struct Coord: Codable, Equatable {
    var lon: Double?
    var lat: Double?
}
