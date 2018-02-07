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
    var backgroundViews = [UIView]()

    func addThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changedTheme), name: Notification.Name("ChangedTheme"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ChangedTheme"), object: nil)
    }

    @objc func changedTheme(_ sender: Any) {
        applyTheme()
    }

    func applyTheme() {
        DispatchQueue.main.async {
            for label in self.titleLabels {
                label.textColor = UserDefaultsManager.theme.titleTextColor
            }

            for label in self.subtitleLabels {
                label.textColor = UserDefaultsManager.theme.lightTextColor
            }

            for view in self.backgroundViews {
                view.backgroundColor = UserDefaultsManager.theme.backgroundColor
            }
            self.contentView.backgroundColor = UserDefaultsManager.theme.backgroundColor
        }
    }

    override func awakeFromNib() {
        addThemeObserver()
        applyTheme()
        super.awakeFromNib()
    }
}
