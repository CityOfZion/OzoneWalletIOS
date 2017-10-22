//
//  AssetCollectionViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class AssetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var assetAmountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.assetNameLabel.textColor = UserDefaultsManager.theme.titleTextColor
            self.assetAmountLabel.textColor = UserDefaultsManager.theme.titleTextColor
        }
    }

    struct AssetData {
        var assetName: String
        var assetAmount: Double
        var precision: Int
    }

    var data: AssetData? {
        didSet {
            assetNameLabel.text = data?.assetName
            assetAmountLabel.text = data?.assetAmount.string((data?.precision)!)
        }
    }
}
