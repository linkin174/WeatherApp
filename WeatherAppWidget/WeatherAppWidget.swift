//
//  WeatherAppWidget.swift
//  WeatherAppWidget
//
//  Created by Aleksandr Kretov on 21.01.2023.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(),
                     currentWeather: CurrentWeather(cityName: "Chelyabinsk", temp: -12, description: "Overccast clouds"))
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(),
                                 currentWeather: CurrentWeather(cityName: "Chelyabinsk", temp: -12, description: "Overccast clouds"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WeatherEntry(date: Date(),
                                     currentWeather: CurrentWeather(cityName: "Chelyabinsk", temp: -12, description: "Overccast clouds"))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let currentWeather: CurrentWeather
}

struct WeatherAppWidgetEntryView: View {
    var entry: WeatherEntry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.blue.gradient)
            VStack(spacing: 4) {
                HStack {
                    Text(entry.currentWeather.cityName)
                        .font(.callout.bold())
                        .foregroundColor(.white.opacity(0.8))
                    Image("01")
                        .resizable(resizingMode: .stretch)
                        .clipped()
                        .frame(width: 30, height: 30)
                }
                Text("\(Int.random(in: -30...30))")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(entry.currentWeather.description)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.white)
                Text(entry.date.formatted(date: .omitted, time: .shortened))
                    .foregroundColor(.white)
                    .font(.system(size: 14, design: .rounded))
            }
        }
    }
}

struct WeatherAppWidget: Widget {
    let kind: String = "WeatherAppWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherAppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather")
        .description("Display current weather")
    }
}

struct WeatherAppWidget_Previews: PreviewProvider {
    static var entry = WeatherEntry(date: Date(),
                                    currentWeather: CurrentWeather(cityName: "Chelyabinsk", temp: -12, description: "Overcast clouds"))
    static var previews: some View {
        WeatherAppWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct CurrentWeather {
    let cityName: String
    let temp: Double
    let description: String
}
