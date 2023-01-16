//
//  UILabel + MakeLabel.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 16.01.2023.
//

import UIKit

enum LabelType {
    typealias LabelInfo = (font: UIFont, color: UIColor)

    case regular
    case small
    case extraSmall
    case large
    case extraLarge
    case custom(info: LabelInfo)
    #warning("fix custom")
    var info: LabelInfo {
        switch self {
        case .regular:
            return LabelInfo(font: .systemFont(ofSize: 20), color: .mainTextColor)
        case .small:
            return LabelInfo(font: .systemFont(ofSize: 15), color: .mainTextColor)
        case .extraSmall:
            return LabelInfo(font: .systemFont(ofSize: 13), color: .mainTextColor)
        case .large:
            return LabelInfo(font: .systemFont(ofSize: 25, weight: .semibold), color: .mainTextColor)
        case .extraLarge:
            return LabelInfo(font: .systemFont(ofSize: 34), color: .mainTextColor)
        case .custom(let info):
            return info
        }
    }
}

extension UILabel {
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
