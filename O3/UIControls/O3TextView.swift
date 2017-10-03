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
        self.layer.borderWidth = Theme.Light.borderWidth
        self.layer.cornerRadius = Theme.Light.cornerRadius
        self.layer.borderColor = Theme.Light.borderColor.cgColor
        self.textColor = Theme.Light.textColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

}
