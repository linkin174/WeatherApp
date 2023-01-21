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
}
