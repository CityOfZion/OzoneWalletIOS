//
//  AddressBookEntryTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class AddressBookEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

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
