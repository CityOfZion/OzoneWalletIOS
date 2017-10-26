//
//  WatchOnlyAddressTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class WatchOnlyAddressTableViewCell: ThemedTableCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!

    override func awakeFromNib() {
        subtitleLabels = [addressLabel]
        super.awakeFromNib()
    }

    struct Data {
        var addressName: String
        var address: String
    }

    var data: Data? {
        didSet {
            applyTheme()
            addressLabel.text = data?.address ?? ""
            nicknameLabel.text = data?.addressName ?? ""
        }
    }
}
