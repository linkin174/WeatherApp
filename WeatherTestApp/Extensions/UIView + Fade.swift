//
//  UIView + Fade.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 15.01.2023.
//

import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval,
                delay: TimeInterval = 0,
                options: UIView.AnimationOptions = [],
                completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }

    func pulse(duration: TimeInterval, delay: TimeInterval) {
        UIView.animate(withDuration: duration, delay: delay, options: [.autoreverse, .repeat], animations: {
            self.alpha = 0.5
        })
    }
}
