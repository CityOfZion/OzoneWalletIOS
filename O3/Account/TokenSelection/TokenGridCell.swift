//
//  TokenGridCell.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class TokenGridCell: UICollectionViewCell {
    @IBOutlet weak var tokenSymbolLabel: UILabel!
    @IBOutlet weak var tokenImageView: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    @IBOutlet weak var inWalletImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var data: NEP5Token? {
        didSet {
            guard let token = data else {
                return
            }
            tokenSymbolLabel.text = token.symbol.uppercased()
            tokenNameLabel.text = token.name
            tokenImageView.kf.setImage(with: URL(string: token.logoURL))
        }
    }
}
