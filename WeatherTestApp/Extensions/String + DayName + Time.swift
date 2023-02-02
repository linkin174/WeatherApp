//
//  String + DayName + Time.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 27.01.2023.
//

import Foundation

extension String {

    func dayNameFormat(timezoneShift: Int?) -> String {
        if let timezoneShift {
            return Date().dateFrom(string: self, timezoneShift: Double(timezoneShift))?.dayNameStyle() ?? "--"
        } else {
            return Date().dateFrom(string: self, timezoneShift: nil)?.dayNameStyle() ?? "--"
        }
    }

    func timeAMPMFormat(timezoneShift: Int?) -> String {
        if let timezoneShift {
            return Date().dateFrom(string: self, timezoneShift: Double(timezoneShift))?.hourAMPMStyle() ?? "--"
        } else {
            return Date().dateFrom(string: self, timezoneShift: nil)?.hourAMPMStyle() ?? "--"
        }
    }
}
