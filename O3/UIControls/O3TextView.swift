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
        self.layer.borderWidth = O3Theme.borderWidth
        self.layer.cornerRadius = O3Theme.cornerRadius
        //self.layer.borderColor = UserDefaultsManager.theme.borderColor.cgColor
        self.theme_textColor = O3Theme.titleColorPicker
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

}
