//
//  UnclaimedGASTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

protocol UnclaimGASDelegate {
    func claimButtonTapped()
}

class UnclaimedGASTableViewCell: ThemedTableCell {

    var delegate: UnclaimGASDelegate?
    @IBOutlet weak var cardView: CardView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var claimButton: ShadowedButton! {
        didSet {
            claimButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet var headerLabel: UILabel!
    override func awakeFromNib() {
        titleLabels = [amountLabel]
        backgroundViews = [cardView]
        super.awakeFromNib()
    }

    @objc func buttonTapped(_ sender: Any) {
        if delegate != nil {
            delegate?.claimButtonTapped()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyTheme()
    }
}
