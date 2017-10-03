//
//  WatchOnlyAddressTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class WatchOnlyAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!

    struct Data {
        var addressName: String
        var address: String
    }

    var data: Data? {
        didSet {
            addressLabel.text = data?.address ?? ""
            nicknameLabel.text = data?.addressName ?? ""
        }
    }
}
