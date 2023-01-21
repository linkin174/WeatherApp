//
//  UIView + DropShadow.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 16.01.2023.
//

import UIKit

extension UIView {
    func dropShadow(color: UIColor = .black.withAlphaComponent(0.35), offset: CGSize = .zero, width: CGFloat = 5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = width
        layer.shadowOpacity = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
