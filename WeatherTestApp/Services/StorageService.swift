//
//  StorageService.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 07.12.2022.
//

import Foundation

protocol StorageServiceProtocol {
    func loadCities() -> [City]
    func add(_ city: City)
    func remove(_ city: City)
}

private struct StorageKey {
    static let cities = "cities"
}

final class StorageService: StorageServiceProtocol {

    // MARK: - Private properties

    private let defaults = UserDefaults(suiteName: "group.xxxZZZCCC")

    // MARK: - Public methods

    func add(_ city: City) {
        var cities = loadCities()
        if city.id == 0, cities.isEmpty {
            cities.append(city)
        } else if city.id == 0, !cities.isEmpty{
            cities[0] = city
        } else {
            cities.append(city)
        }
        save(cities)
    }

    func remove(_ city: City) {
        var cities = loadCities()
        cities.removeAll(where: { $0.id == city.id })
        save(cities)
    }

    func loadCities() -> [City] {
        guard let defaults else { return [] }
        guard
            let data = defaults.data(forKey: StorageKey.cities),
            let cities = try? JSONDecoder().decode([City].self, from: data)
        else {
            return []
        }
        print("LOAded cities \(cities.sorted(by: { $0.id ?? 0 < $1.id ?? 0 }).map { $0.name})")
        return cities.sorted(by: { $0.id ?? 0 < $1.id ?? 0 })
    }

    // MARK: - Private methods

    private func save(_ cities: [City]) {
        guard
            let defaults,
            let data = try? JSONEncoder().encode(cities)
        else { return }
        defaults.set(data, forKey: StorageKey.cities)
    }
}
