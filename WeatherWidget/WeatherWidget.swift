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
        WeatherEntry(date: Date(), currentWeather: [CurrentWeather.placeholder])
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), currentWeather: [CurrentWeather.placeholder])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)
        Task {
            let currentWeather = await fetcher.fetchCurrentWeather()
            let entry = WeatherEntry(date: currentDate, currentWeather: currentWeather)
            let timelline = Timeline(entries: [entry], policy: .after(nextDate!))
            completion(timelline)
        }
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let currentWeather: [CurrentWeather]
    let error: String?

    init(date: Date, currentWeather: [CurrentWeather], error: String? = nil) {
        self.date = date
        self.currentWeather = currentWeather
        self.error = error
    }
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry

    #warning("Continue here")
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.linearGradient(colors: [.cyan, .blue],
                                      startPoint: UnitPoint(x: 0, y: 0),
                                      endPoint: UnitPoint(x: 0, y: 1)))
            VStack(spacing: 1) {
                HStack {
                    Text(entry.currentWeather.first!.name ?? "")
                        .font(.body)
                        .foregroundColor(.white)
                    Image(systemName: "location.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 12, height: 12)
                }

                Text("\(getFormattedTemp(entry.currentWeather.first?.main.temp))")
                    .foregroundColor(.white)
                    .font(.system(size: 58, weight: .thin, design: .rounded))

                Spacer()
                if let icon = String(entry.currentWeather.first?.weather.first?.icon?.dropLast() ?? "") {
                    Image(icon)
                        .resizable()
                        .frame(width: 30, height: 30)

                }
                Text("\(entry.currentWeather.first!.weather.first!.description!)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                HStack {
                    Image(systemName: "arrow.down")

                    Text(getFormattedTemp(entry.currentWeather.first?.main.tempMin))
                    Image(systemName: "arrow.up")

                    Text(getFormattedTemp(entry.currentWeather.first?.main.tempMax))

                }
                .foregroundColor(.white)
                .font(.system(size: 12))
            }
            .shadow(radius: 5)
        }
    }

    #warning("Make extension to format temps")
    private func getFormattedTemp(_ temp: Double?) -> String {
        guard let temp else { return "--" }
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.minimumFractionDigits = 0
        let rounded = Double(Int(temp.rounded()))
        let measurment = Measurement(value: rounded, unit: UnitTemperature.celsius)
        let string = formatter.string(from: measurment)
        return String(string.dropLast(1))
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    let fetcher: WeatherFetchingProtocol = FetcherService()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(fetcher: fetcher)) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), currentWeather: [CurrentWeather.placeholder]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
