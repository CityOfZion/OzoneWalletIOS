//
//  NativeAssetTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class NativeAssetTableViewCell: ThemedTableCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        titleLabels = [titleLabel, amountLabel]
        backgroundViews = [cardView]
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyTheme()
    }

}
