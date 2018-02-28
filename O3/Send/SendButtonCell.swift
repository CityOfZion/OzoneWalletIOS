//
//  SendButtonCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/11/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class SendButtonCell: UITableViewCell {
    override func awakeFromNib() {
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }
}
