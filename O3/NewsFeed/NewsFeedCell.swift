//
//  NewsFeedRow.swift
//  O3
//
//  Created by Andrei Terentiev on 1/8/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedCell: UITableViewCell {
    @IBOutlet weak var newsRowImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!

    override func awakeFromNib() {
        newsTitleLabel.theme_textColor = O3Theme.titleColorPicker
        newsDateLabel.theme_textColor = O3Theme.lightTextColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }
}
