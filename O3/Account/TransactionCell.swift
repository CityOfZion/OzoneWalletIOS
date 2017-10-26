//
//  transactionCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/13/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class TransactionCell: ThemedTableCell {
    enum TransactionType: String {
        case send = "Sent"
        case claim = "Claimed"
        case recieved = "Recieved"

    }
    struct TransactionData {
        var type: TransactionType
        var date: UInt64 // Use block number for now
        var asset: String // Will prolly need to switch this to assettype as some point
        var address: String
        var amount: Double
        var precision: Int = 0
    }

    @IBOutlet weak var transactionTypeLabel: UILabel?
    @IBOutlet weak var transactionTimeLabel: UILabel?
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        titleLabels = [assetLabel]
        subtitleLabels = [addressLabel]
        super.awakeFromNib()
    }

    var data: TransactionData? {
        didSet {
            applyTheme()
            assetLabel.text = data?.asset.uppercased()
            addressLabel.text = data?.address
            amountLabel.text = data?.amount.stringWithSign((data?.precision)!)
            amountLabel.textColor = data?.amount ?? 0 <= 0 ? UserDefaultsManager.theme.negativeLossColor : UserDefaultsManager.theme.positiveGainColor
        }
    }
}
