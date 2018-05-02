//
//  TokenSaleInfoRowCell.swift
//  O3
//
//  Created by Andrei Terentiev on 4/12/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class TokenSaleInfoRowTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    struct InfoData {
        var title: String
        var subtitle: String
    }

    var infoData: InfoData? {
        didSet {
            titleLabel.text = infoData?.title ?? ""
            subtitleLabel.text = infoData?.subtitle ?? ""
        }
    }

    override func awakeFromNib() {
        titleLabel.theme_textColor = O3Theme.lightTextColorPicker
        subtitleLabel.theme_textColor = O3Theme.titleColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }
}
