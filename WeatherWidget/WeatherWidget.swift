//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Aleksandr Kretov on 24.01.2023.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    private let fetcher: WeatherFetchingProtocol
    private let userDefaults = UserDefaults(suiteName: "group.xxxZZZCCC")

    init(fetcher: WeatherFetchingProtocol) {
        self.fetcher = fetcher
    }

    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), currentWeather: CurrentWeather.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), currentWeather: CurrentWeather.placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)
        Task {
            do {
                let currentWeather = try await fetcher.fetchCurrentWeather()
                let entry = WeatherEntry(date: currentDate, currentWeather: currentWeather)
                let timelline = Timeline(entries: [entry], policy: .after(nextDate!))
                completion(timelline)
            } catch {
                let entry = WeatherEntry(date: currentDate, currentWeather: nil, error: error.localizedDescription)
                let timeLine = Timeline(entries: [entry], policy: .after(nextDate!))
                completion(timeLine)
            }
        }
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let currentWeather: CurrentWeather?
    let error: String?

    init(date: Date, currentWeather: CurrentWeather?, error: String? = nil) {
        self.date = date
        self.currentWeather = currentWeather
        self.error = error
    }
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.linearGradient(colors: [.cyan, .blue],
                                      startPoint: UnitPoint(x: 0, y: 0),
                                      endPoint: UnitPoint(x: 1, y: 1)))
            if let error = entry.error {
                ErrorView(errorMessage: error)
            } else if let weather = entry.currentWeather {
                WeatherView(weather: weather)
                    .frame(height: 100)
            }
        }
        .shadow(radius: 5)
    }
}

struct WeatherView: View {
    let weather: CurrentWeather

    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Text(weather.name ?? "")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                if weather.id == 0 {
                    Image(systemName: "location.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 12, height: 12)
                }
            }
            Text(weather.main.temp?.tempFormat() ?? "")
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .thin, design: .rounded))
            if let icon = String(weather.weather.first!.icon?.dropLast() ?? "") {
                Image(icon)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            Text(weather.weather.first!.description ?? "")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            HStack {
                Image(systemName: "arrow.down")
                Text(weather.main.tempMin?.tempFormat() ?? "")
                    .font(.system(size: 13, design: .rounded))
                Image(systemName: "arrow.up")
                Text(weather.main.tempMax?.tempFormat() ?? "")
                    .font(.system(size: 13, design: .rounded))
            }
            .foregroundColor(.white)
            .font(.system(size: 12))
        }
        .padding(4)
    }
}

struct ErrorView: View {
    let errorMessage: String

    var body: some View {
        ZStack {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .opacity(0.1)
            VStack(spacing: 16) {
                Text("Error loading widget:")
                    .foregroundColor(.white)
                    .font(.system(size: 13, design: .rounded))
                    .multilineTextAlignment(.center)
                Text(errorMessage)
                    .foregroundColor(.white)
                    .font(.system(size: 13, design: .rounded).bold())
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    let fetcher: WeatherFetchingProtocol = WidgetFetcherService()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(fetcher: fetcher)) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static let errorEntry = WeatherEntry(date: Date(), currentWeather: nil, error: "Bad response")
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), currentWeather: CurrentWeather.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        WeatherWidgetEntryView(entry: errorEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
