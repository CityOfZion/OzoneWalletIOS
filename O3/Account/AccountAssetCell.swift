//
//  AssetCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/13/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class AccountAssetCell: UITableViewCell {
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var assetAmountLabel: UILabel!
    @IBOutlet weak var gradientBackgroundImageView: UIImageView!

    struct AssetData {
        var assetName: String
        var assetAmount: Double
    }

    var data: AssetData? {
        didSet {
            assetNameLabel.text = data?.assetName
            assetAmountLabel.text = data?.assetAmount.description
        }
    }
}
