//
//  SearchedCity.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 31.12.2022.
//

import Foundation

// MARK: - CityElement

typealias SearchedCities = [CityElement]

struct CityElement: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}


