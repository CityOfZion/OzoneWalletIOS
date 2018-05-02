//
//  TokenSaleSuccessViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/16/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import Lottie

class TokenSaleSuccessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var animationView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var transactionCardView: UIView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var transactionInfo: TokenSaleTableViewController.TokenSaleTransactionInfo!

    func setThemedElements() {
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        transactionCardView.theme_backgroundColor = O3Theme.cardColorPicker
        tableView.theme_backgroundColor = O3Theme.cardColorPicker
        statusLabel.theme_textColor = O3Theme.accentColorPicker
    }

    var tokenSaleTransactionItems: [TokenSaleTransactionInfoTableViewCell.TokenSaleTransactionItem]! = []

    func buildTransactionInfoForTable() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm ZZZZZ"
        let localDate = dateFormatter.string(from: now)

        let dateItem = TokenSaleTransactionInfoTableViewCell.TokenSaleTransactionItem(title: TokenSaleStrings.dateReceiptLabel, value: localDate)
        tokenSaleTransactionItems.append(dateItem)

        let tokenSale = TokenSaleTransactionInfoTableViewCell.TokenSaleTransactionItem(title: TokenSaleStrings.tokenSaleNameReceiptLabel, value: transactionInfo.saleInfo.name)
        tokenSaleTransactionItems.append(tokenSale)

        let txID = TokenSaleTransactionInfoTableViewCell.TokenSaleTransactionItem(title: TokenSaleStrings.txidReceiptLabel, value: transactionInfo.txID)
        tokenSaleTransactionItems.append(txID)

        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.numberStyle = .decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true

        let sending = TokenSaleTransactionInfoTableViewCell.TokenSaleTransactionItem(title: TokenSaleStrings.sendingReceiptLabel, value: String(format: "%@ %@", amountFormatter.string(from: NSNumber(value: transactionInfo.assetAmount))!, transactionInfo.assetNameUsedToPurchase))
        tokenSaleTransactionItems.append(sending)

        let forTokens = TokenSaleTransactionInfoTableViewCell.TokenSaleTransactionItem(title: TokenSaleStrings.receivingReceiptLabel, value: String(format: "%@ %@", amountFormatter.string(from: NSNumber(value: transactionInfo.tokensToRecieveAmount))!, transactionInfo.tokensToReceiveName))
        tokenSaleTransactionItems.append(forTokens)

        //better move fee to its own const
        if transactionInfo.priorityIncluded == true {
            let priority = TokenSaleTransactionInfoTableViewCell.TokenSaleTransactionItem(title: TokenSaleStrings.priorityReceiptLabel, value: "0.0011 GAS")
            tokenSaleTransactionItems.append(priority)
        }

        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        setThemedElements()
        let lottieView = LOTAnimationView(name: "success-blue")
        lottieView.frame = animationView.bounds
        animationView.addSubview(lottieView)
        lottieView.play { (_) in

        }

        //build transaction for the table
        buildTransactionInfoForTable()
    }

    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func shareTapped(_ sender: Any) {
        let text = String(format: TokenSaleStrings.emailReceipt, tokenSaleTransactionItems[0].value, tokenSaleTransactionItems[1].value, tokenSaleTransactionItems[2].value, tokenSaleTransactionItems[3].value, tokenSaleTransactionItems[4].value)
        let transactionCard = UIImage.imageWithView(view: self.transactionCardView)
        let activityViewController = UIActivityViewController(activityItems: [text, transactionCard], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension TokenSaleSuccessViewController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokenSaleTransactionItems.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TokenSaleTransactionInfoTableViewCell else {
            return UITableViewCell()
        }
        let item = tokenSaleTransactionItems[indexPath.row]
        cell.info = item
        return cell
    }

    func setLocalizedStrings() {
        statusLabel.text = TokenSaleStrings.successfulTransaction
        transactionLabel.text = TokenSaleStrings.transactionTitle
    saveButton.setTitle(TokenSaleStrings.saveTitle, for: UIControlState())
        closeButton.setTitle(TokenSaleStrings.closeTitle, for: UIControlState())
    }

}
