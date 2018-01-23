//
//  NEP5TokenTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class NEP5TokenTableViewCell: ThemedTableCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var loadingView: UIActivityIndicatorView?

    override func awakeFromNib() {
        titleLabels = [titleLabel, amountLabel]
        super.awakeFromNib()
    }
}
