//
//  CardView.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class CardView: UIView {

    var shadowLayer: CAShapeLayer!
    override var backgroundColor: UIColor? {
        didSet {
            if shadowLayer != nil {
               shadowLayer.fillColor = UserDefaultsManager.themeIndex == 0 ?  Theme.light.cardColor.cgColor : Theme.dark.cardColor.cgColor
            }
        }
    }

    func setupView() {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = false
        self.theme_backgroundColor = O3Theme.cardColorPicker
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
            shadowLayer.fillColor = UserDefaultsManager.themeIndex == 0 ? Theme.light.cardColor.cgColor : Theme.dark.cardColor.cgColor

            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 2

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }

    override func prepareForInterfaceBuilder() {
        self.setupView()
    }

}
