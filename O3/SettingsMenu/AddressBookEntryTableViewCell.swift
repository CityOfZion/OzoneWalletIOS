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
