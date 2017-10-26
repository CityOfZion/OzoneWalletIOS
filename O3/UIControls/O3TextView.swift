//
//  O3TextView.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/23/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class O3TextView: UITextView {

    func setupView() {
        self.clipsToBounds = true
        self.layer.borderWidth = ThemeManager.borderWidth
        self.layer.cornerRadius = ThemeManager.cornerRadius
        self.layer.borderColor = UserDefaultsManager.theme.borderColor.cgColor
        self.textColor = UserDefaultsManager.theme.textColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

}
