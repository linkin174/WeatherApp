//
//  City.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 06.12.2022.
//

import Foundation

struct City: Codable, Identifiable, Equatable {
    var name: String?
    var coord: Coord?
    var country: String?
    var population: Int?
    var timezone: Int?
    var sunrise: Int?
    var sunset: Int?
    var id: Int?
}

// MARK: - Coord
struct Coord: Codable, Equatable {
    var lon: Double?
    var lat: Double?
}
