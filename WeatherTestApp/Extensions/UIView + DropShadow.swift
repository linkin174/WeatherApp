//
//  UIView + DropShadow.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 16.01.2023.
//

import UIKit

extension UIView {
    func dropShadow(color: UIColor = .black.withAlphaComponent(0.35), offsetX: CGFloat = 0, offsetY: CGFloat = 0, width: CGFloat = 5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowRadius = width
        layer.shadowOpacity = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
