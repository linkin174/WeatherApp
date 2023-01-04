//
//  UIView + Separator.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 24.12.2022.
//

import UIKit

//extension UIView {
//    enum Edge {
//        case top, bottom
//    }
//
//    func addSeparator(color: UIColor, edges: [Edge], thickness: CGFloat = 0.5, widthInset: CGFloat = 0) {
//        edges.forEach { edge in
//            let view = UIView()
//            view.translatesAutoresizingMaskIntoConstraints = false
//            view.backgroundColor = color
//            addSubview(view)
//
//            switch edge {
//            case .top:
//                view.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            default:
//                view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//            }
//            view.heightAnchor.constraint(equalToConstant: thickness).isActive = true
//            view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//            view.widthAnchor.constraint(equalTo: widthAnchor, constant: -widthInset * 2).isActive = true
//        }
//    }
//}
