//
//  HeaderTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

class HeaderTableViewCell: ThemedTableCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        titleLabels = [titleLabel]
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyTheme()
    }
}
