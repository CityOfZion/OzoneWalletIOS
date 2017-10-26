//
//  TransactionsHeaderCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/13/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class TransactionsHeaderCell: ThemedTableCell {
    @IBOutlet weak var historyTitleLabel: UILabel!

    override func awakeFromNib() {
        titleLabels = [historyTitleLabel]
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        historyTitleLabel.text = "Transaction history"
    }
}
