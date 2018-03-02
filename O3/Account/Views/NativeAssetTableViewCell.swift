//
//  NativeAssetTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class NativeAssetTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        titleLabel.theme_textColor = O3Theme.titleColorPicker
        amountLabel.theme_textColor = O3Theme.titleColorPicker
        cardView.theme_backgroundColor = O3Theme.backgroundColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        cardView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.layoutSubviews()
    }

}
