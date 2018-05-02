//
//  ContributionTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 4/13/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift

protocol ContributionCellDelegate: class {
    func setContributionAmount(amountString: String)
    func setContributionAsset(asset: TransferableAsset)
    func setTokenAmount(totalTokens: Double)
}

class ContributionTableViewCell: UITableViewCell {
    weak var delegate: ContributionCellDelegate?

    var inputToolbar: AssetInputToolbar?

    @IBOutlet weak var neoSelectorContainerView: UIView!
    @IBOutlet weak var gasSelectorContainerView: UIView!
    @IBOutlet weak var neoContainerLabel: UILabel!
    @IBOutlet weak var gasContainerLabel: UILabel!
    @IBOutlet weak var neoRateLabel: UILabel!
    @IBOutlet weak var gasRateLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var receiveTitleLabel: UILabel!

    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            inputToolbar = AssetInputToolbar()
            inputToolbar?.delegate = self
            amountTextField.inputAccessoryView = inputToolbar?.loadNib()
            amountTextField.inputAccessoryView?.theme_backgroundColor = O3Theme.backgroundColorPicker

            var neo = TransferableAsset.NEO()
            neo.balance = Decimal(O3Cache.neoBalance())
            inputToolbar?.asset = neo
        }
    }

    @IBOutlet weak var tokenAmountLabel: UILabel!
    @IBOutlet weak var acceptingAssetHint: UILabel!

    var neoRateInfo: TokenSales.SaleInfo.AcceptingAsset?
    var gasRateInfo: TokenSales.SaleInfo.AcceptingAsset?

    var tokenName: String! {
        didSet {
            neoRateLabel.text = "1 NEO = " + (neoRateInfo?.basicRate.string(0, removeTrailing: true) ?? "") + " " + tokenName
            gasRateLabel.text = "1 GAS = " + (gasRateInfo?.basicRate.string(0, removeTrailing: true) ?? "") + " " + tokenName
        }
    }
    var selectedAsset: TransferableAsset = TransferableAsset.NEO() {
        didSet {
            acceptingAssetHint.text = selectedAsset.symbol.uppercased()
        }
    }

    func setThemedElements() {
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        theme_backgroundColor = O3Theme.backgroundColorPicker
        amountTextField.theme_backgroundColor = O3Theme.textFieldBackgroundColorPicker
        amountTextField.theme_textColor = O3Theme.textFieldTextColorPicker
        amountTextField.theme_keyboardAppearance = O3Theme.keyboardPicker
    }

    @IBAction func contributionAmountChanged(_ sender: Any) {
        //simple validation with number only field
        let amountString = amountTextField.text?.trim() ?? ""
        if amountString == "" {
            tokenAmountLabel.text = String(format: "0 %@", tokenName)
            delegate?.setContributionAmount(amountString: amountString)
            delegate?.setTokenAmount(totalTokens: 0)
            return
        }

        //formatter to format string to a proper numbers
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = selectedAsset.decimal
        amountFormatter.numberStyle = .decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true

        let amount = amountFormatter.number(from: (amountString.trim()))

        if amount == nil {
            return
        }

        //calculate the rate
        let rate = selectedAsset.symbol.lowercased() == "neo" ? neoRateInfo : gasRateInfo
        let totalTokens = amount!.doubleValue * (rate?.basicRate ?? 0)

        tokenAmountLabel.text = String(format: "%@ %@", amountFormatter.string(from: NSNumber(value: totalTokens))!, tokenName)
        delegate?.setContributionAmount(amountString: amountString)
        delegate?.setTokenAmount(totalTokens: totalTokens)
    }

    //When switch between NEO/GAS
    @objc func setContributionAsset(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            self.amountTextField.resignFirstResponder()

            //reset the field when switch the contributing asset
            self.amountTextField.text = ""
            if sender.view == self.neoSelectorContainerView {
                var neo = TransferableAsset.NEO()
                neo.balance = Decimal(O3Cache.neoBalance())
                self.inputToolbar?.asset = neo
                self.amountTextField.keyboardType = .numberPad
                //allow only integer for neo
                self.neoSelectorContainerView.borderColor = Theme.light.primaryColor
                self.neoContainerLabel.textColor = Theme.light.primaryColor
                self.neoRateLabel.textColor = Theme.light.primaryColor

                self.gasSelectorContainerView.borderColor = Theme.light.lightTextColor
                self.gasContainerLabel.textColor = Theme.light.lightTextColor
                self.gasRateLabel.textColor = Theme.light.lightTextColor

                self.delegate?.setContributionAsset(asset: TransferableAsset.NEO())
                self.selectedAsset = TransferableAsset.NEO()
                self.contributionAmountChanged(sender)
            } else {

                var gas = TransferableAsset.GAS()
                gas.balance = Decimal(O3Cache.gasBalance())
                self.inputToolbar?.asset = gas

                self.amountTextField.keyboardType = .decimalPad

                self.gasSelectorContainerView.borderColor = Theme.light.primaryColor
                self.gasContainerLabel.textColor = Theme.light.primaryColor
                self.gasRateLabel.textColor = Theme.light.primaryColor

                self.neoSelectorContainerView.borderColor = Theme.light.lightTextColor
                self.neoContainerLabel.textColor = Theme.light.lightTextColor
                self.neoRateLabel.textColor = Theme.light.lightTextColor

                self.delegate?.setContributionAsset(asset: TransferableAsset.GAS())
                self.selectedAsset = TransferableAsset.GAS()
                self.contributionAmountChanged(sender)
            }
        }
    }

    override func awakeFromNib() {
        setThemedElements()
        receiveTitleLabel.text = TokenSaleStrings.youWillReceiveTitle
        neoSelectorContainerView.isUserInteractionEnabled = true
        gasSelectorContainerView.isUserInteractionEnabled = true
        neoSelectorContainerView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.setContributionAsset(_:))))
        gasSelectorContainerView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.setContributionAsset(_:))))
        super.awakeFromNib()
    }
}
extension ContributionTableViewCell: AssetInputToolbarDelegate {

    func maxAmountTapped(value: Decimal) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = selectedAsset.decimal
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        let balanceString = formatter.string(for: value)
        amountTextField.text = balanceString
        contributionAmountChanged(amountTextField)
    }

    func percentAmountTapped(value: Decimal) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = selectedAsset.decimal
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false

        let balanceString = formatter.string(for: value)
        amountTextField.text = balanceString
        contributionAmountChanged(amountTextField)
    }

}
