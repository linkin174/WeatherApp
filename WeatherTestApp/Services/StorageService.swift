//
//  StorageService.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 07.12.2022.
//

import Foundation

protocol StorageServiceProtocol {
    func getCities() -> [City]
    func save(_ city: City)
    func remove(cityID: Int)
}

final class StorageService: StorageServiceProtocol {

    // MARK: - Private properties

    private let defaults = UserDefaults(suiteName: "group.WeatherTestApp")
    private var cities: [City] = []

    // MARK: - Initializers
    init() {
        self.cities = loadCities()
    }

    // MARK: - Public methods

    func getCities() -> [City] {
        cities
    }

    func save(_ city: City) {
        if city.id == 0, !cities.isEmpty {
            if cities.contains(where: { $0.id == 0 }) {
                cities[0] = city
            } else {
                cities.insert(city, at: 0)
            }
        } else {
            cities.append(city)
        }
        save(cities)
    }

    func remove(cityID: Int) {
        cities.removeAll(where: { $0.id == cityID })
        save(cities)
    }



    // MARK: - Private methods

    private func loadCities() -> [City] {
        guard
            let defaults,
            let data = defaults.data(forKey: "cities"),
            let cities = try? JSONDecoder().decode([City].self, from: data)
        else {
            return []
        }
        return cities
    }
    
    private func save(_ cities: [City]) {
        guard
            let defaults,
            let data = try? JSONEncoder().encode(cities)
        else { return }
        defaults.set(data, forKey: "cities")
    }
}
