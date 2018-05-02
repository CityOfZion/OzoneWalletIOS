//
//  AddAddressTableCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

protocol AddAddressCellDelegate: class {
    func segueToAdd()
}

class AddAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var addAddressButton: ShadowedButton!
    weak var delegate: AddAddressCellDelegate?
    override func awakeFromNib() {
        addAddressButton.setTitle(SettingsStrings.addWatchAddressButton, for: UIControlState())
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    @IBAction func addAddressTapped(_ sender: Any) {
        delegate?.segueToAdd()
    }

}
