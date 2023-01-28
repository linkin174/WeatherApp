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
    func remove(_ city: City)
}

final class StorageService: StorageServiceProtocol {

    // MARK: - Private properties

    private let defaults = UserDefaults(suiteName: "group.xxxZZZCCC")
    private var cities: [City] = []

    // MARK: - Initializers
    init() {
        self.cities = loadCities()
    }

    // MARK: - Public methods

    func save(_ city: City) {
        if city.id == 0, cities.isEmpty {
            cities.append(city)
        } else if city.id == 0, !cities.isEmpty {
            cities[0] = city
        } else {
            cities.append(city)
        }
        save(cities)
    }

    func remove(_ city: City) {
        cities.removeAll(where: { $0.id == city.id })
        save(cities)
    }

    func getCities() -> [City] {
        return cities
    }


    // MARK: - Private methods

    private func loadCities() -> [City] {
        guard let defaults else { return [] }
        guard
            let data = defaults.data(forKey: "cities"),
            let cities = try? JSONDecoder().decode([City].self, from: data)
        else {
            return []
        }

        print("Cities from storage \(cities.map { $0.id })")
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
