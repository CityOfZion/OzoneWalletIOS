//
//  TokenSaleTransactionInfoTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/18/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class TokenSaleTransactionInfoTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var ValueLabel: UILabel?

    struct TokenSaleTransactionItem {
        var title: String
        var value: String
    }

    var info: TokenSaleTransactionItem! {
        didSet {
            titleLabel?.text = info.title
            ValueLabel?.text = info.value
        }
    }

    override func awakeFromNib() {
        titleLabel?.theme_textColor = O3Theme.lightTextColorPicker
        ValueLabel?.theme_textColor = O3Theme.titleColorPicker
        contentView.theme_backgroundColor = O3Theme.cardColorPicker
        theme_backgroundColor = O3Theme.cardColorPicker
        super.awakeFromNib()
    }
}
