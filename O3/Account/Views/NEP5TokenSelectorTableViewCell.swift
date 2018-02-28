//
//  NEP5TokenSelectorTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/7/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class NEP5TokenSelectorTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var loadingView: UIActivityIndicatorView?

    override func awakeFromNib() {
        titleLabel.theme_textColor = O3Theme.titleColorPicker
        amountLabel.theme_textColor = O3Theme.titleColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        backgroundView = UIView()
        backgroundView?.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
