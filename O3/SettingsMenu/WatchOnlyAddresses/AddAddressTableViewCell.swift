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
    weak var delegate: AddAddressCellDelegate?
    override func awakeFromNib() {
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    @IBAction func addAddressTapped(_ sender: Any) {
        delegate?.segueToAdd()
    }

}
