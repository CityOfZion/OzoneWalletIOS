//
//  WalletHeaderCollectionCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/24/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

protocol WalletHeaderCellDelegate: class {
    func didTapLeft(index: Int, portfolioType: PortfolioType)
    func didTapRight(index: Int, portfolioType: PortfolioType)
}

class WalletHeaderCollectionCell: UICollectionViewCell {
    struct Data {
        var portfolioType: PortfolioType
        var index: Int
        var latestPrice: PriceData
        var previousPrice: PriceData
        var referenceCurrency: Currency
        var selectedInterval: PriceInterval
    }
    @IBOutlet weak var walletHeaderLabel: UILabel!
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!

    weak var delegate: WalletHeaderCellDelegate?
    var data: WalletHeaderCollectionCell.Data? {
        didSet {
            guard let portfolio = data?.portfolioType,
                let latestPrice = data?.latestPrice,
                let previousPrice = data?.previousPrice,
                let referenceCurrency = data?.referenceCurrency,
                let selectedInterval = data?.selectedInterval else {
                    fatalError("Cell is missing type")
            }
            switch portfolio {
            case .readOnly:
                walletHeaderLabel.text = "OZONE WALLET"
                leftButton.isHidden = true
                rightButton.isHidden = false
            case .readOnlyAndWritable:
                walletHeaderLabel.text = "COMBINED"
                rightButton.isHidden = true
                leftButton.isHidden = false
            default:
                walletHeaderLabel.text = "COLD STORAGE"
                rightButton.isHidden = false
                leftButton.isHidden = false
            }
            switch referenceCurrency {
            case .btc:
                portfolioValueLabel.text = String(format: "%.8fBTC", latestPrice.averageBTC)
            case .usd:
                portfolioValueLabel.text = USD(amount: Float(latestPrice.averageUSD)).formattedString()
            }
            percentChangeLabel.text = String.percentChangeString(latestPrice: latestPrice, previousPrice: previousPrice,
                                                                 with: selectedInterval, referenceCurrency: referenceCurrency)
            percentChangeLabel.textColor = latestPrice.averageBTC >= previousPrice.averageBTC ? UserDefaultsManager.theme.positiveGainColor : UserDefaultsManager.theme.negativeLossColor
        }
    }

    @IBAction func didTapRight(_ sender: Any) {
        guard let index = data?.index,
            let portfolioType = data?.portfolioType else {
                fatalError("undefined collection view cell behavior")
        }
        delegate?.didTapRight(index: index, portfolioType: portfolioType)
    }

    @IBAction func didTapLeft(_ sender: Any) {
        guard let index = data?.index,
            let portfolioType = data?.portfolioType else {
            fatalError("undefined collection view cell behavior")
        }
        delegate?.didTapLeft(index: index, portfolioType: portfolioType)
    }
}
