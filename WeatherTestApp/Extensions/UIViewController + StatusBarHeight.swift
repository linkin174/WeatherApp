//
//  UIViewController + TopBarHeight.swift
//  LoremPicsumApp
//
//  Created by Aleksandr Kretov on 04.12.2022.
//

import UIKit

extension UIViewController {
    var statusBarHeight: CGFloat {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let height = scene.statusBarManager?.statusBarFrame.height
        else {
            return 0
        }
        return height
    }
}
