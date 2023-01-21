//
//  PlaceElement.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 05.01.2023.
//

import Foundation

struct Place: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
