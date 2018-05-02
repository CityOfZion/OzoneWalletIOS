//
//  UINavigationController.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

extension UINavigationController {

    internal func findHairline(view: UIView) {
        for v in view.subviews {
            if let hairlineView = v as? UIImageView {
                hairlineView.isHidden = hairlineView.bounds.size.height == (1 / UIScreen.main.scale) ? true : false
                break
            }
            findHairline(view: v)
        }
    }

    func hideHairline() {
        findHairline(view: self.view)
    }

}

extension UISearchBar {

    internal func findHairline(view: UIView) {
        for v in view.subviews {
            if let hairlineView = v as? UIImageView {
                hairlineView.isHidden = hairlineView.bounds.size.height == (1 / UIScreen.main.scale) ? true : false
                break
            }
            findHairline(view: v)
        }
    }

    func hideHairline() {
        findHairline(view: self)
    }

}
