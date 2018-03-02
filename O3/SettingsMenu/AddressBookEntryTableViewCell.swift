//
//  AddressBookEntryTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/5/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class AddressBookEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        addressLabel.theme_textColor = O3Theme.lightTextColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    struct Data {
        var addressName: String
        var address: String
    }

    var data: AddressBookEntryTableViewCell.Data? {
        didSet {
            addressNameLabel.text = data?.addressName ?? ""
            addressLabel.text = data?.address ?? ""
        }
    }
}
