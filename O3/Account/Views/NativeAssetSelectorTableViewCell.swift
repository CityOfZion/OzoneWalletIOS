//
//  NativeAssetSelectorTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/7/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
class NativeAssetSelectorTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!

    override func awakeFromNib() {
        titleLabel.theme_textColor = O3Theme.titleColorPicker
        amountLabel.theme_textColor = O3Theme.titleColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
