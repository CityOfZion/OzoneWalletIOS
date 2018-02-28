//
//  NetworkSeedCell.swift
//  O3
//
//  Created by Andrei Terentiev on 10/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift

protocol NetworkSeedCellDelegate: class {
    func highestBlockCount() -> UInt
}

class NetworkSeedCell: UITableViewCell {
    @IBOutlet weak var seedNameLabel: UILabel!
    @IBOutlet weak var blockCountLabel: UILabel!
    @IBOutlet weak var peersLabel: UILabel!
    weak var delegate: NetworkSeedCellDelegate?

    override func awakeFromNib() {
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    var node: NEONode? {
        didSet {
            guard delegate != nil,
                node?.blockCount != nil else {
                    return
            }
            seedNameLabel.text = node?.URL
            blockCountLabel.text = node?.blockCount.description
            peersLabel.text = node?.peerCount.description
            DispatchQueue.main.async {
                if self.node?.URL == Neo.sharedMain?.seed {
                    self.accessoryType = .checkmark
                    self.accessoryView?.backgroundColor = UserDefaultsManager.theme.backgroundColor
                } else {
                    self.accessoryType = .none
                }
            }

            if (delegate?.highestBlockCount() ?? 0) - (node?.blockCount ?? 0)  > 5 { //give a small amount of buffer for unaligned blocks
                DispatchQueue.main.async {
                    self.blockCountLabel.textColor = UserDefaultsManager.theme.errorColor
                    self.seedNameLabel.textColor = UserDefaultsManager.theme.errorColor
                    self.peersLabel.textColor = UserDefaultsManager.theme.errorColor
                }
            } else {
                DispatchQueue.main.async {
                    self.blockCountLabel.textColor = UserDefaultsManager.theme.primaryColor
                    self.peersLabel.textColor = UserDefaultsManager.theme.accentColor
                    self.seedNameLabel.textColor = UserDefaultsManager.theme.titleTextColor
                }
            }
        }
    }
}
