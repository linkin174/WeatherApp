//
//  Date + FormatStyle.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 21.01.2023.
//

import Foundation

extension Date {
    func shortTimeStyle(adding timeInterval: Double = 0) -> String {
        let delta = timeInterval - Double(TimeZone.current.secondsFromGMT())
        return self.addingTimeInterval(delta).formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
    }

    func hourAMPMStyle() -> String {
        return self.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)))
    }

    func dayNameStyle() -> String {
        self.formatted(.dateTime.weekday(.wide))
    }

    func dateFrom(string: String, timezoneShift: Double?) -> Self? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let timezoneShift {
            return formatter.date(from: string)?.addingTimeInterval(timezoneShift)
        } else {
            return formatter.date(from: string)
        }
    }

    func dateFrom(secondsUTC: Int) -> Self {
        Date(timeIntervalSince1970: Double(secondsUTC))
    }
}
