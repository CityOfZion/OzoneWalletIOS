//
//  NewsFeedRow.swift
//  O3
//
//  Created by Andrei Terentiev on 1/8/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedCell: ThemedTableCell {
    @IBOutlet weak var newsRowImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!

    override func awakeFromNib() {
        titleLabels = [newsTitleLabel]
        subtitleLabels = [newsDateLabel]
        super.awakeFromNib()
    }
}
