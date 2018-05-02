//
//  UIView.swift
//  O3
//
//  Created by Andrei Terentiev on 9/24/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func  shakeToShowError() {
        let maxShakes = 6
        let shakeDuration = 0.05
        let shakeTransform = 6.0 as CGFloat
        var direction = 1.0 as CGFloat

        for i in 0...maxShakes {
            UIView.animate(
                withDuration: shakeDuration,
                delay: shakeDuration * Double(i),
                options: .curveEaseIn,
                animations: {
                    if i >= maxShakes {
                        self.transform = CGAffineTransform.identity
                    } else {
                        self.transform = CGAffineTransform(translationX: shakeTransform * direction, y: 0)
                    }
            },
                completion: nil
            )

            direction *= -1
        }
    }

    func embed(_ embeddedView: UIView) {
        self.addSubview(embeddedView)
        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": embeddedView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": embeddedView]))
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"

        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
