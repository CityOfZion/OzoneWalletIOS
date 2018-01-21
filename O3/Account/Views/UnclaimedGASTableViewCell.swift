//
//  UnclaimedGASTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class UnclaimedGASTableViewCell: UITableViewCell {

    @IBOutlet var amountLabel: UILabel!

    @IBOutlet var claimButton: ShadowedButton!

    @IBOutlet var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
