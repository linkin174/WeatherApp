//
//  PlaceElement.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 05.01.2023.
//

import Foundation

struct PlaceElement: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case lat = "lat"
        case lon = "lon"
        case country = "country"
        case state = "state"
    }
}