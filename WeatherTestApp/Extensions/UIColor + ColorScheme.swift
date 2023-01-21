//
//  UIColor + ColorScheme.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 06.01.2023.
//

import UIKit

extension UIColor {
    
   class var mainBackground: UIColor {
        UIColor(named: "mainBG") ?? .black
    }

    class var secondaryBackground: UIColor {
        UIColor(named: "secondaryBG") ?? .black
    }
}
