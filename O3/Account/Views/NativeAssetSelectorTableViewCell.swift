//
//  NativeAssetSelectorTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/7/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
class NativeAssetSelectorTableViewCell: ThemedTableCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!

    override func awakeFromNib() {
        titleLabels = [titleLabel, amountLabel]
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyTheme()
    }

}
