//
//  ShadowedButton.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

import UIKit

class ShadowedButton: UIButton {

    var shadowLayer: CAShapeLayer!

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled == true ? Theme.Light.primary : Theme.Light.lightgrey
            if shadowLayer != nil {
                shadowLayer.shadowOpacity = isEnabled == true ? 0.8 : 0
                shadowLayer.fillColor = isEnabled == true ? Theme.Light.primary.cgColor : UIColor.clear.cgColor
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = isEnabled == true ? Theme.Light.primary : Theme.Light.lightgrey
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 22).cgPath
            shadowLayer.fillColor = isEnabled == true ? Theme.Light.primary.cgColor : UIColor.clear.cgColor
            shadowLayer.shadowColor = Theme.Light.grey.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity =  isEnabled == true ? 0.8 : 0
            shadowLayer.shadowRadius = 2

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        shadowLayer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        shadowLayer.shadowOpacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.8
        super.touchesEnded(touches, with: event)
    }
}
