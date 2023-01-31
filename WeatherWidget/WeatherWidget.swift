//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Aleksandr Kretov on 24.01.2023.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    // MARK: - Private properties

    private let fetcher: WeatherFetchingProtocol
    private let locationService: LocationServiceProtocol

    // MARK - Initializers

    init(fetcher: WeatherFetchingProtocol, locationService: LocationServiceProtocol) {
        self.fetcher = fetcher
        self.locationService = locationService
    }

    // MARK: - Public Methods
    
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
        locationService.getLocation { location in
            if let location {
                let city = City(coord: Coord(lon: location.coordinate.longitude,
                                             lat: location.coordinate.latitude))
                Task {
                    do {
                        let currentWeather = try await fetcher.fetchCurrentWeather(for: city)
                        let entry = WeatherEntry(date: currentDate, currentWeather: currentWeather)
                        let timelline = Timeline(entries: [entry], policy: .after(nextDate!))
                        completion(timelline)
                    } catch {
                        let entry = WeatherEntry(date: currentDate, currentWeather: nil, error: error.localizedDescription)
                        let timeLine = Timeline(entries: [entry], policy: .after(nextDate!))
                        completion(timeLine)
                    }
                }
            } else {
                let entry = WeatherEntry(date: currentDate, currentWeather: nil, error: "Location services disabled")
                let timeline = Timeline(entries: [entry], policy: .never)
                completion(timeline)
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
        .widgetURL(URL(string: "\(entry.currentWeather?.id ?? 0)"))
    }
}

struct WeatherView: View {
    let weather: CurrentWeather

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(weather.name ?? "")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Image(systemName: "location.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 12, height: 12)
            }
            HStack(spacing: 8) {
                if let icon = String(weather.weather.first!.icon?.dropLast() ?? "") {
                    Image(icon)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .opacity(0.8)
                }
                Text(weather.main.temp?.tempFormat() ?? "")
                    .foregroundColor(.white)
                    .font(.system(size: 48, weight: .thin, design: .rounded))
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
            .padding(.horizontal, 8)
        }
    }
}

struct WeatherWidget: Widget {

    let kind: String = "WeatherWidget"
    let fetcher = WidgetFetcherService()
    let locationService = LocationService()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(fetcher: fetcher, locationService: locationService)) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather")
        .description("Simple widget to show weather in your current location")
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
