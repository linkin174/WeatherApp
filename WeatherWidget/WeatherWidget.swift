//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Aleksandr Kretov on 24.01.2023.
//

import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {

    // MARK: - Private properties

    private let fetcher: WeatherFetchingProtocol
    private let locationService: LocationServiceProtocol

    // MARK: - Initializers

    init(fetcher: WeatherFetchingProtocol, locationService: LocationServiceProtocol) {
        self.fetcher = fetcher
        self.locationService = locationService
    }

    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), currentWeather: CurrentWeather.placeholder)
    }

    func getSnapshot(for configuration: SelectLocationIntent, in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let entry = WeatherEntry(date: Date(), currentWeather: CurrentWeather.placeholder)
        completion(entry)
    }

    func getTimeline(for configuration: SelectLocationIntent, in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        guard let locationType = configuration.location else { return }
        if locationType.cityID as? Int == 0 {
            locationService.getLocation { location in
                let city = City(coord: Coord(lon: location?.coordinate.longitude,
                                             lat: location?.coordinate.latitude),
                                id: 0)
                Task {
                    let timeline = await makeTimeline(for: city)
                    completion(timeline)
                }
            }
        } else {
            let city = City(coord: Coord(lon: configuration.location?.longitude as? Double,
                                         lat: configuration.location?.latitude as? Double),
                            id: configuration.location?.cityID as? Int)
            Task {
                let timeline = await makeTimeline(for: city)
                completion(timeline)
            }
        }
    }

    private func makeTimeline(for city: City) async -> Timeline<WeatherEntry> {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)
        var timeline: Timeline<WeatherEntry>!
        do {
            let currentWeather = try await fetcher.fetchCurrentWeather(for: city)
            let entry = WeatherEntry(date: currentDate, currentWeather: currentWeather)
            timeline = Timeline(entries: [entry], policy: .after(nextDate!))
        } catch {
            let entry = WeatherEntry(date: currentDate, currentWeather: nil, error: error.localizedDescription)
            timeline = Timeline(entries: [entry], policy: .after(nextDate!))
        }
        return timeline
    }

    private func city(for configuration: SelectLocationIntent) -> City {
        City(name: configuration.location?.displayString,
             coord: Coord(lon: configuration.location?.longitude as? Double,
                          lat: configuration.location?.latitude as? Double),
             id: configuration.location?.cityID as? Int)
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
    @Environment(\.colorScheme) var colorScheme

    var gradientColors: [Color] {
        colorScheme == .light ? [Color.cyan, Color.blue] : [Color.black, Color.blue.opacity(0.6)]
    }

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.linearGradient(colors: gradientColors,
                                      startPoint: UnitPoint(x: 0, y: 0),
                                      endPoint: UnitPoint(x: 1, y: 1)))
            if let error = entry.error {
                ErrorView(errorMessage: error)
            } else if let weather = entry.currentWeather {
                WeatherView(weather: weather)
            }
        }
        .shadow(radius: 5)
    }
}

struct WeatherView: View {
    let weather: CurrentWeather

    @Environment(\.colorScheme) private var colorScheme
    private var textColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color.white
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(weather.name ?? "")
                    .font(.system(size: 16, design: .rounded))
                    .lineLimit(1)
                if weather.id == 0 {
                    Image(systemName: "location.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                }
            }
            HStack(spacing: 8) {
                if let icon = String(weather.weather.first!.icon?.dropLast() ?? "") {
                    Image(icon)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .opacity(0.8)
                }
                Text(weather.main.temp?.tempFormat() ?? "")
                    .font(.system(size: 48, weight: .thin, design: .rounded))
            }
            Text(weather.weather.first!.description?.capitalized ?? "")
                .font(.system(size: 14, weight: .bold, design: .rounded))
            HStack {
                Image(systemName: "arrow.down")
                Text(weather.main.tempMin?.tempFormat() ?? "")
                    .font(.system(size: 13, design: .rounded))
                Image(systemName: "arrow.up")
                Text(weather.main.tempMax?.tempFormat() ?? "")
                    .font(.system(size: 13, design: .rounded))
            }
            .font(.system(size: 12))
        }
        .foregroundColor(textColor)
        .padding(4)
    }
}

struct ErrorView: View {

    let errorMessage: String

    @Environment(\.colorScheme) private var colorScheme

    private var textColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color.white
    }

    var body: some View {
        ZStack {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .frame(width: 110, height: 100)
                .foregroundColor(.white)
                .opacity(0.1)
            VStack(spacing: 16) {
                Text("Error loading widget:")
                    .font(.system(size: 13, design: .rounded))
                    .multilineTextAlignment(.center)
                Text(errorMessage)
                    .font(.system(size: 13, design: .rounded).bold())
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(textColor)
            .padding(.horizontal, 8)
        }
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    let fetcher = WidgetFetcherService()
    let locationService = LocationService()

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: SelectLocationIntent.self,
                            provider: Provider(fetcher: fetcher, locationService: locationService)) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather")
        .description("Get the weather forecast for the selected location")
        .supportedFamilies([.systemSmall])
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static let errorEntry = WeatherEntry(date: Date(), currentWeather: nil, error: "Location Services Disabled")
    static var previews: some View {
        Group {
            WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), currentWeather: CurrentWeather.placeholder))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            WeatherWidgetEntryView(entry: errorEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
