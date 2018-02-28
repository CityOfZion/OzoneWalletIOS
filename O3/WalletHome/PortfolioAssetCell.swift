//
//  PortfolioAssetCell.swift
//  O3
//
//  Created by Andrei Terentiev on 2/6/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import SwiftTheme

class PortfolioAssetCell: UITableViewCell {
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetAmountLabel: UILabel!
    @IBOutlet weak var assetFiatPriceLabel: UILabel!
    @IBOutlet weak var assetFiatAmountLabel: UILabel!
    @IBOutlet weak var assetPercentChangeLabel: UILabel!

    struct Data {
        var assetName: String
        var amount: Double
        var referenceCurrency: Currency
        var latestPrice: PriceData
        var firstPrice: PriceData
    }

    override func awakeFromNib() {
        let titleLabels = [assetTitleLabel, assetAmountLabel, assetFiatAmountLabel]
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        for label in titleLabels {
            label?.theme_textColor = O3Theme.titleColorPicker
        }
        assetFiatPriceLabel.theme_textColor = O3Theme.lightTextColorPicker
        super.awakeFromNib()
    }

    var data: PortfolioAssetCell.Data? {
        didSet {
            guard let assetName = data?.assetName,
                let amount = data?.amount,
                let referenceCurrency = data?.referenceCurrency,
                let latestPrice = data?.latestPrice,
                let firstPrice = data?.firstPrice else {
                    fatalError("undefined data set")
            }
            assetTitleLabel.text = assetName
            assetAmountLabel.text = amount.description

            let precision = referenceCurrency == .btc ? Precision.btc : Precision.usd
            let referencePrice = referenceCurrency == .btc ? latestPrice.averageBTC : latestPrice.average
            let referenceFirstPrice = referenceCurrency == .btc ? firstPrice.averageBTC : firstPrice.average

            assetFiatPriceLabel.text = referencePrice.string(precision)
            assetFiatAmountLabel.text = (referencePrice * Double(amount)).string(precision)
            //format USD properly
            if referenceCurrency == .usd {
                assetFiatPriceLabel.text = Fiat(amount: Float(referencePrice)).formattedString()
            }

            assetPercentChangeLabel.text = String.percentChangeStringShort(latestPrice: latestPrice, previousPrice: firstPrice,
                                                                           referenceCurrency: referenceCurrency)
            assetPercentChangeLabel.textColor = referencePrice >= referenceFirstPrice ? UserDefaultsManager.theme.positiveGainColor : UserDefaultsManager.theme.negativeLossColor
        }
    }
}
