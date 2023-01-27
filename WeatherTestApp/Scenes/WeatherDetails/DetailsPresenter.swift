//
//  DetailsPresenter.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 10.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailsPresentationLogic {
    func presentCurrentWeather(response: Details.ShowCurrentWeather.Response)
    func presentForecast(response: Details.ShowForecast.Response)
    func presentError(response: Details.HandleError.Response)
}

class DetailsPresenter: DetailsPresentationLogic {
    // MARK: - Public Properties

    weak var viewController: DetailsDisplayLogic?

    // MARK: - Presentation Logic
    
    func presentCurrentWeather(response: Details.ShowCurrentWeather.Response) {
        let temp = response.weather.main.temp?.tempFormat() ?? "--"
        let description = response.weather.weather.first?.main?.description
        let hiTemp = response.weather.main.tempMax?.tempFormat() ?? "--"
        let loTemp = response.weather.main.tempMin?.tempFormat() ?? "--"
        let headerViewModel = HeaderViewModel(cityName: response.weather.name ?? "--",
                                              temp: temp,
                                              conditionDescription: description ?? "---",
                                              hiTemp: hiTemp,
                                              lowTemp: loTemp)
        let viewModel = Details.ShowCurrentWeather.ViewModel(headerViewModel: headerViewModel)
        viewController?.displayCurrentWeather(viewModel: viewModel)
    }

    func presentForecast(response: Details.ShowForecast.Response) {
        let forecast = response.forecast
        let hourlyViewModels = makeHourlyViewModels(from: forecast)
        let dailyViewModels = makeDailyViewModels(from: forecast)
        let miscViewModel = makeMiscInfoViewModel(from: response.currentweather, and: forecast.list.first)
        let viewModel = Details.ShowForecast.ViewModel(hourlyForecastViewModels: hourlyViewModels,
                                                       dailyForecastViewModels: dailyViewModels,
                                                       miscInfoViewModel: miscViewModel)

        viewController?.displayDetailedForecast(viewModel: viewModel)
    }

    func presentError(response: Details.HandleError.Response) {
        let viewModel = Details.HandleError.ViewModel(errorMessage: response.error.localizedDescription)
        viewController?.displayError(viewModel: viewModel)
    }


    // MARK: - Private Methods

    private func makeHourlyViewModels(from: DailyForecast) -> [HourlyCellViewModelProtocol] {
        let forecastForPeriod = from.list.prefix(16).map { $0 }
        return forecastForPeriod.map { hourly in
            HourlyCellViewModel(timeTitle: hourly.dtTxt.timeAMPMFormat(timezoneShift: from.city.timezone),
                                iconName: String(hourly.weather.first?.icon?.dropLast() ?? ""),
                                tempTitle: hourly.main.temp?.tempFormat() ?? "")
        }
    }

    private func makeDailyViewModels(from forecast: DailyForecast) -> [DayForecastViewModel] {
        Dictionary(grouping: forecast.list) { $0.dtTxt.dayNameFormat(timezoneShift: forecast.city.timezone) }
            .sorted { $0.value.first?.dt ?? 0 < $1.value.first?.dt ?? 0 }
            .reduce(into: [DayForecastViewModel]()) { partialResult, element in
                let temps = getMinMax(from: element.value)
                let icon = getWeatherIconForDay(from: element.value)
                let pop = getPrecicipationAvarage(from: element.value)
                let viewModel = DayForecastViewModel(dayName: element.key,
                                                     iconName: icon,
                                                     precipitationTitle: pop,
                                                     dayTemp: temps.max.tempFormat(withDegreeSign: false),
                                                     nightTemp: temps.max.tempFormat(withDegreeSign: false))
                partialResult.append(viewModel)
                partialResult[0].dayName = "Today"
            }
    }

    private func makeMiscInfoViewModel(from currentWeather: CurrentWeather, and hourly: Hourly?) -> MiscInfoViewModelProtocol {
        var weatherDescription: String {
            guard let description = currentWeather.weather.first?.description else { return "Right now is great weather!" }
            var text = "Right now is \(description)."
            if let gust = currentWeather.wind.gust {
                text += " Wind gusts are up to \(Int(gust)) m/s."
            }
            return text
        }

        let sunriseTime = Date().dateFrom(secondsUTC: currentWeather.sys.sunrise).shortTimeStyle()

        let sunsetTime = Date().dateFrom(secondsUTC: currentWeather.sys.sunset).shortTimeStyle()

        var chanceOfPop: String {
            if let hourly {
                return "\(Int(hourly.pop * 100)) %"
            } else {
                return "0 %"
            }
        }

        let humidity = String(currentWeather.main.humidity ?? 0) + "%"

        let feelsLike = currentWeather.main.feelsLike?.tempFormat() ?? "--"

        var isRain: Bool {
            currentWeather.main.temp ?? 0 > 0
        }

        var popVolume: String {
            if let snowVolume = currentWeather.snow?.oneHour {
                return String(Int(snowVolume)) + " mm"
            } else if let rainVolume = currentWeather.rain?.oneHour {
                return String(Int(rainVolume)) + " mm"
            }
            return "0 mm"
        }

        let pressure = String(currentWeather.main.pressure ?? 0) + " hPa"

        var visability: String {
            let value = currentWeather.visibility
            if value < 1000 {
                return String(value) + " m"
            } else {
                return String(value / 1000) + " km"
            }
        }

        return MiscInfoViewModel(weatherDescription: weatherDescription,
                                 sunriseTime: sunriseTime,
                                 sunsetTime: sunsetTime,
                                 chanceOfPop: chanceOfPop,
                                 humidity: humidity,
                                 wind: currentWeather.wind.description,
                                 feelsLike: feelsLike,
                                 precipitation: popVolume,
                                 pressure: pressure,
                                 visibility: visability,
                                 uvIndex: "0",
                                 isRain: isRain)
    }

    private func getPrecicipationAvarage(from dailyForecast: [Hourly]) -> String? {
        // Calculate avarage precipitation chance
        let pop = dailyForecast.map { $0.pop }
        let avarege = pop.reduce(0, +) / Double(pop.count)
        let roundedToPercents = Int(avarege * 100)
        return roundedToPercents != 0 ? "\(roundedToPercents)%" : nil
    }
    private func getWeatherIconForDay(from dailyForecast: [Hourly]) -> String {
        // Find most recent weather icon for that day
        let iconName = dailyForecast.reduce(into: String()) { partialResult, _ in
            partialResult = Dictionary(grouping: dailyForecast) { $0.weather.first?.icon }
                .sorted { $0.value.count > $1.value.count }
                .first?.value.first?.weather.first?.icon ?? ""
        }
        return String(iconName.dropLast())
    }

    // This is needed because API sends min and max temps for only some cities. In all other cases they are equal
    // Lets fix this by finding min and max temp in hourly forecasts of current day
    private func getMinMax(from dailyForecast: [Hourly]) -> (min: Double, max: Double) {
        let min = dailyForecast.min { $0.main.temp ?? 0 < $1.main.temp ?? 0 }?.main.temp ?? 0
        let max = dailyForecast.max { $0.main.temp ?? 0 < $1.main.temp ?? 0 }?.main.temp ?? 0
        return (min, max)
    }
}
