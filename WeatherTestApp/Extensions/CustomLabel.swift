//
//  CustomLabel.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 17.01.2023.
//

import UIKit

@IBDesignable final class CustomLabel: UILabel {

    @IBInspectable var dropShadow: Bool {
        get {
            self.layer.shadowRadius == 0
        } set(state) {
            if state {
                self.layer.shadowRadius = shadowRadius
                self.layer.shadowColor = shadowColor?.cgColor
                self.layer.shadowOffset = shadowOffset
                self.layer.shadowOpacity = 1
                self.layer.shouldRasterize = true
                self.layer.rasterizationScale = UIScreen.main.scale
            }
        }
    }

    @IBInspectable override var shadowColor: UIColor? {
        get {
            if let color = self.layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        } set(color) {
            self.layer.shadowColor = color?.cgColor
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            self.layer.shadowRadius
        } set(radius) {
            self.layer.shadowRadius = radius
        }
    }

    @IBInspectable override var shadowOffset: CGSize {
        get {
            self.layer.shadowOffset
        } set(offset) {
            self.layer.shadowOffset = CGSize(width: offset.width, height: offset.height)
        }
    }
}
