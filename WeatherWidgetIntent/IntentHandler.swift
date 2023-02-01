//
//  IntentHandler.swift
//  WeatherWidgetIntent
//
//  Created by Aleksandr Kretov on 01.02.2023.
//

import Intents

class IntentHandler: INExtension {

    private let userDefaults = UserDefaults(suiteName: "group.WeatherTestApp")
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: DynamicCitySelectionIntentHandling {
    func provideCityTypeOptionsCollection(for intent: DynamicCitySelectionIntent) async -> INObjectCollection<CityType> {
        guard
            let data = userDefaults?.data(forKey: "cities"),
            let decoded = try? JSONDecoder().decode([City].self, from: data)
        else { return INObjectCollection(items: [])}
        let items: [CityType] = decoded.map { city in
            if city.id == 0 {
                return CityType(identifier: "home", display: "Current location")
            } else {
                return CityType(identifier: String(city.id ?? 0), display: city.name ?? "")
            }
        }
        let collection = INObjectCollection(items: items)
        return collection
    }
}
