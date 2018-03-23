//
//  FeaturedCollectionCell.swift
//  O3
//
//  Created by Andrei Terentiev on 3/19/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class FeaturedCollectionCell: UICollectionViewCell {
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.theme_textColor = O3Theme.primaryColorPicker
        subtitleLabel.theme_textColor = O3Theme.lightTextColorPicker
    }
}
