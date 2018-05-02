//
//  NumberOnlyUITextField.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/17/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class NumberOnlyUITextField: NoActionUITextField, UITextFieldDelegate {

    override func awakeFromNib() {
        delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string.hasPrefix("0") {
            return false
        }
        let allowedCharacters = CharacterSet.decimalDigits.union (CharacterSet (charactersIn: ".")).union (CharacterSet (charactersIn: ","))
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
