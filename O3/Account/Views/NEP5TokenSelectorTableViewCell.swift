//
//  NEP5TokenSelectorTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/7/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class NEP5TokenSelectorTableViewCell: ThemedTableCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var loadingView: UIActivityIndicatorView?

    override func awakeFromNib() {
        titleLabels = [titleLabel, amountLabel]
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyTheme()
    }
}
