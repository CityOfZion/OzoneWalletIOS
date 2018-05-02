//
//  NoActionUITextField.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/17/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class NoActionUITextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}
