//
//  Double + AsTemp.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 27.01.2023.
//

import Foundation

extension Double {
    public func tempFormat(withDegreeSign: Bool = true) -> String {
       let formatter = MeasurementFormatter()
       formatter.numberFormatter.maximumFractionDigits = 0
       formatter.numberFormatter.minimumFractionDigits = 0
       let rounded = Double(Int(self.rounded()))
       let measurement = Measurement(value: rounded, unit: UnitTemperature.celsius)
       let string = formatter.string(from: measurement)
       if withDegreeSign {
           return String(string.dropLast(1))
       } else {
           return String(string.dropLast(2))
       }
    }
}
