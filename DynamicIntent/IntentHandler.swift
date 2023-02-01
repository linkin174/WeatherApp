//
//  IntentHandler.swift
//  DynamicIntent
//
//  Created by Aleksandr Kretov on 01.02.2023.
//

import Intents
import UIKit

class IntentHandler: INExtension {
    // MARK: - Private properties

    private let userDefaults = UserDefaults(suiteName: "group.WeatherTestApp")
    private var cities: [City] = []
    private var notificationObserver: NSObjectProtocol?

    override func handler(for intent: INIntent) -> Any {
        return self
    }

    // MARK: - Initializers

    override init() {
        super.init()
        loadCities()
    }

    // MARK: - Private Methods

    private func makeLocationType(from city: City) -> LocationType {
        let type = LocationType(identifier: String(city.id ?? 0),
                                display: city.id == 0 ? "Current Location" : city.name ?? "")
        type.cityID = NSNumber(value: city.id ?? 0)
        type.latitude = NSNumber(value: city.coord?.lat ?? 0)
        type.longitude = NSNumber(value: city.coord?.lon ?? 0)
        return type
    }

    private func loadCities() {
        guard
            let data = userDefaults?.data(forKey: "cities"),
            let cities = try? JSONDecoder().decode([City].self, from: data)
        else {
            return
        }
        self.cities = cities
    }
}

// MARK: - Extensions

extension IntentHandler: SelectLocationIntentHandling {
    func defaultLocation(for intent: SelectLocationIntent) -> LocationType? {
        guard let firstCity = cities.first else { return nil }
        let type = makeLocationType(from: firstCity)
        return type
    }

    func provideLocationOptionsCollection(for intent: SelectLocationIntent) async -> INObjectCollection<LocationType> {
        let locationTypes = cities.map { makeLocationType(from: $0) }
        return INObjectCollection(items: locationTypes)
    }
}
