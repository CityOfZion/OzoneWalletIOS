//
//  AddressBookEntryTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class AddressBookEntryTableViewCell: ThemedTableCell {
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        subtitleLabels = [addressLabel]
        super.awakeFromNib()
    }

    struct Data {
        var addressName: String
        var address: String
    }

    var data: AddressBookEntryTableViewCell.Data? {
        didSet {
            applyTheme()
            addressNameLabel.text = data?.addressName ?? ""
            addressLabel.text = data?.address ?? ""
        }
    }
}
