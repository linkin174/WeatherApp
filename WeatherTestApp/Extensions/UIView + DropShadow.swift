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

    func dropContactShadow(color: UIColor = .black, height: CGFloat = 10, horizontalPadding: CGFloat = 5, radius: CGFloat = 5) {
        let contactRect = CGRect(x: bounds.minX - horizontalPadding,
                                 y: bounds.maxY - (height * 0.5),
                                 width: bounds.width + horizontalPadding * 2,
                                 height: height)
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.25
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
