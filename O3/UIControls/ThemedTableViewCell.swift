//
//  ThemedTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 10/22/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class ThemedTableCell: UITableViewCell {
    var titleLabels = [UILabel]()
    var subtitleLabels = [UILabel]()

    override func awakeFromNib() {
        DispatchQueue.main.async {
            for label in self.titleLabels {
                label.textColor = UserDefaultsManager.theme.titleTextColor
            }

            for label in self.subtitleLabels {
                label.textColor = UserDefaultsManager.theme.lightTextColor
            }
            self.contentView.backgroundColor = UserDefaultsManager.theme.backgroundColor
        }
        super.awakeFromNib()
    }
}
