//
//  TransactionsHeaderCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/13/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class TransactionsHeaderCell: UITableViewCell {
    @IBOutlet weak var historyTitleLabel: UILabel!

    override func awakeFromNib() {
        historyTitleLabel.theme_textColor = O3Theme.titleColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        historyTitleLabel.text = "Transaction history"
    }
}
