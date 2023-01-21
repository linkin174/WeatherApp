//
//  UILabel + MakeLabel.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 16.01.2023.
//

import UIKit

extension UILabel {

    typealias LabelInfo = (font: UIFont, color: UIColor)

    enum LabelType {

        case regular
        case small
        case extraSmall
        case large
        case extraLarge
        case custom(info: LabelInfo)

        var info: LabelInfo {
            switch self {
            case .regular:
                return LabelInfo(font: .systemFont(ofSize: 20), color: .white)
            case .small:
                return LabelInfo(font: .systemFont(ofSize: 15), color: .white)
            case .extraSmall:
                return LabelInfo(font: .systemFont(ofSize: 13), color: .white)
            case .large:
                return LabelInfo(font: .systemFont(ofSize: 25, weight: .semibold), color: .white)
            case .extraLarge:
                return LabelInfo(font: .systemFont(ofSize: 34), color: .white)
            case .custom(let info):
                return info
            }
        }
    }

    static func makeLabel(title: String = "", type: LabelType, withShadow: Bool = true) -> UILabel {
        let label = UILabel()
        label.textColor = type.info.color
        label.text = title
        label.font = type.info.font
        if withShadow {
            label.dropShadow()
        }
        return label
    }
}
