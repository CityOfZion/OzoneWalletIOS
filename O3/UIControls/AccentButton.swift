//
//  AccentButton.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class AccentButton: UIButton {

    var shadowLayer: CAShapeLayer!

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled == true ?  UserDefaultsManager.theme.accentColor : UserDefaultsManager.theme.disabledColor
            if shadowLayer != nil {
                shadowLayer.shadowOpacity = isEnabled == true ? 0.8 : 0
                shadowLayer.fillColor = isEnabled == true ? UserDefaultsManager.theme.accentColor.cgColor : UIColor.clear.cgColor
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = isEnabled == true ? UserDefaultsManager.theme.accentColor : UserDefaultsManager.theme.disabledColor
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
            shadowLayer.fillColor = isEnabled == true ? UserDefaultsManager.theme.accentColor.cgColor : UIColor.clear.cgColor
            shadowLayer.shadowColor = UserDefaultsManager.theme.disabledColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity =  isEnabled == true ? 0.8 : 0
            shadowLayer.shadowRadius = 2
            layer.insertSublayer(shadowLayer, at: 0)
            self.clipsToBounds = false
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
