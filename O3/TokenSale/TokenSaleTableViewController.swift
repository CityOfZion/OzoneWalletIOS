//
//  TokenSaleTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 4/12/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import WebBrowser

class TokenSaleTableViewController: UITableViewController, ContributionCellDelegate {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var participateButton: ShadowedButton!
    @IBOutlet weak var priorityInfoButton: UIButton!
    @IBOutlet var priorityLabel: UILabel?
    @IBOutlet var checkboxPriority: UIButton?

    var saleInfo: TokenSales.SaleInfo!
    var selectedAsset: TransferableAsset? = TransferableAsset.NEO()
    var neoRateInfo: TokenSales.SaleInfo.AcceptingAsset?
    var gasRateInfo: TokenSales.SaleInfo.AcceptingAsset?
    var amountString: String?
    var totalTokens: Double = 0.0
    var endingSoon: Bool = false

    public struct TokenSaleTransactionInfo {
        var priorityIncluded: Bool
        var assetIDUsedToPurchase: String
        var assetNameUsedToPurchase: String
        var assetAmount: Double
        var tokenSaleContractHash: String
        var tokensToRecieveAmount: Double
        var tokensToReceiveName: String
        var saleInfo: TokenSales.SaleInfo
        //this will be set when submitting the raw transaction
        var txID: String
    }

    func setThemedElements() {
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        priorityInfoButton.theme_setTitleColor(O3Theme.lightTextColorPicker, forState: UIControlState())
    }

    func setAssetRateInfo() {
        guard let neoIndex = saleInfo.acceptingAssets.index (where: {$0.asset.lowercased() == "neo" }),
            let gasIndex = saleInfo.acceptingAssets.index (where: {$0.asset.lowercased() == "gas" }) else {
                return
        }
        neoRateInfo = saleInfo.acceptingAssets[neoIndex]
        gasRateInfo = saleInfo.acceptingAssets[gasIndex]
    }
    var countdownTimer: Timer?

    deinit {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.title = saleInfo.name

        let date1: Date = Date()
        let date2: Date = Date(timeIntervalSince1970: saleInfo.endTime)
        let calender: Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.hour], from: date1, to: date2)
        //less than 6 hours
        if  components.hour! < 6 {
            self.endingSoon =  true
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownDate), userInfo: nil, repeats: true)
        }

        self.navigationItem.largeTitleDisplayMode = .never
        participateButton.isEnabled = false
        self.tableView.keyboardDismissMode = .onDrag
        setThemedElements()
        logoImageView.kf.setImage(with: URL(string: saleInfo.imageURL))
        setAssetRateInfo()
        let tap = UITapGestureRecognizer(target: self, action: #selector(priorityLabelTapped(_:)))
        priorityLabel?.addGestureRecognizer(tap)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "external-link-alt"), style: .plain, target: self, action: #selector(externalLinkTapped(_:)))
    }

    @objc func countDownDate() {
        let now = Date()
        let calendar = Calendar.current
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.calendar = calendar
        let tokenSaleEndDate = Date(timeIntervalSince1970: saleInfo.endTime)
        let string = formatter.string(from: now, to: tokenSaleEndDate)!
        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TokenSaleInfoRowTableViewCell {
            DispatchQueue.main.async {
                if tokenSaleEndDate < now {
                    cell.subtitleLabel.text = TokenSaleStrings.ended
                    cell.subtitleLabel.theme_textColor = O3Theme.negativeLossColorPicker
                    self.countdownTimer?.invalidate()
                    self.countdownTimer = nil
                } else {
                    cell.subtitleLabel.text = string
                    cell.subtitleLabel.theme_textColor = O3Theme.negativeLossColorPicker
                }

            }
        }
    }

    @objc func externalLinkTapped(_ sender: Any) {
        let webBrowserViewController = WebBrowserViewController()
        webBrowserViewController.isToolbarHidden = false
        webBrowserViewController.title = saleInfo.name
        webBrowserViewController.isShowURLInNavigationBarWhenLoading = true
        webBrowserViewController.barTintColor = UserDefaultsManager.themeIndex == 0 ? Theme.light.backgroundColor: Theme.dark.backgroundColor
        webBrowserViewController.tintColor = Theme.light.primaryColor
        webBrowserViewController.isShowPageTitleInNavigationBar = true
        webBrowserViewController.loadURLString(saleInfo.webURL)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(webBrowserViewController, animated: true)
        }
    }

    @objc func priorityLabelTapped(_ sender: Any) {
        //toggel when tap at the label
        checkboxPriority!.isSelected = !checkboxPriority!.isSelected
    }

    @IBAction func priorityTapped(_ sender: Any) {
        checkboxPriority!.isSelected = !checkboxPriority!.isSelected
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return 35.0
        }

        if indexPath.section == 2 {
            return 218.0
        }

        return 35
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //ending soon section will show only when the sale is less than 6 hours
        if section == 0 {
            if endingSoon == true {
                return 1
            }
            return 0
        }

        //sales info section
        if section == 1 {
            return saleInfo.info.count
        }

        //contribution cell
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func amountStringToNumber(amountString: String) -> NSNumber? {
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.numberStyle = .decimal
        amountFormatter.maximumFractionDigits = self.selectedAsset!.decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true
        return amountFormatter.number(from: amountString)
    }

    func validateAmount(amountString: String) -> Bool {
        let contributionIndexPath = IndexPath(row: 0, section: 2)
        guard let cell = tableView.cellForRow(at: contributionIndexPath) as? ContributionTableViewCell else {
            return false
        }
        //clear error message label
        cell.errorLabel.text = ""

        if amountString.count == 0 {
            return false
        }

        let assetName: String! = self.selectedAsset?.name!
        let amount = amountStringToNumber(amountString: amountString)

        if amount == nil {
            OzoneAlert.alertDialog(message: TokenSaleStrings.invalidAmountError, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
            return false
        }

        //validation
        //1. check balance first
        //2. check min/max contribution

        //validate amount
        if amount!.decimalValue > self.selectedAsset!.balance! {
            let balanceDecimal = self.selectedAsset!.balance
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = self.selectedAsset!.decimal
            formatter.numberStyle = .decimal
            let balanceString = formatter.string(for: balanceDecimal)
            let message = String(format: TokenSaleStrings.notEnoughBalanceError, assetName, balanceString!)
            OzoneAlert.alertDialog(message: message, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
            return false
        } else if selectedAsset?.name.lowercased() == "gas" && self.selectedAsset!.balance! - amount!.decimalValue <= 0.00000001 {
            OzoneAlert.alertDialog(message: TokenSaleStrings.roundingError, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
            return false
        }

        let filteredResults = saleInfo.acceptingAssets.filter { (asset) -> Bool in
            return asset.asset.lowercased() == self.selectedAsset?.name.lowercased()
        }

        //showing a message instead of an alert
        if filteredResults.count == 1 {
            let contributingAsset = filteredResults.first!
            if amount!.doubleValue > contributingAsset.max {
                cell.errorLabel.shakeToShowError()
                let message = String(format: TokenSaleStrings.maxContributionError, contributingAsset.asset.uppercased(), contributingAsset.max.string(0, removeTrailing: true))
                cell.errorLabel.text = message
                return false
            }

            if amount!.doubleValue < contributingAsset.min {
                cell.errorLabel.shakeToShowError()
                let message = String(format: TokenSaleStrings.minContributionError, contributingAsset.asset.uppercased(), contributingAsset.min.string(8, removeTrailing: true))
                cell.errorLabel.text = message
                return false
            }
        }

        return true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ending soon section
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tokenSaleInfoRowTableViewCell") as? TokenSaleInfoRowTableViewCell else {
                return UITableViewCell()
            }

            let infoRowData = TokenSaleInfoRowTableViewCell.InfoData(title: TokenSaleStrings.endsIn, subtitle: "")
            cell.infoData = infoRowData
            return cell
        }

        //contribution section
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tokenSaleInfoRowTableViewCell") as? TokenSaleInfoRowTableViewCell else {
                return UITableViewCell()
            }

            let infoRow = saleInfo.info[indexPath.row]
            let infoRowData = TokenSaleInfoRowTableViewCell.InfoData(title: infoRow.label, subtitle: infoRow.value)
            cell.infoData = infoRowData
            return cell

        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contributionTableViewCell") as? ContributionTableViewCell else {
            return UITableViewCell()
        }

        cell.delegate = self
        cell.neoRateInfo = neoRateInfo
        cell.gasRateInfo = gasRateInfo
        cell.tokenName = saleInfo.symbol
        //init with 0
        cell.tokenAmountLabel.text = String(format: "0 %@", saleInfo.symbol)
        return cell
    }

    @IBAction func particpateTapped(_ sender: Any) {
        DispatchQueue.main.async {

            let date1: Date = Date()
            let date2: Date = Date(timeIntervalSince1970: self.saleInfo.endTime)
            let calender: Calendar = Calendar.current
            let components: DateComponents = calender.dateComponents([.second], from: date1, to: date2)
            //already ended
            if  components.second! < 0 {
                let message = String(format: TokenSaleStrings.tokenSaleHasEndedError, self.saleInfo.name)
                OzoneAlert.alertDialog(message: message, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
                return
            }

            if self.validateAmount(amountString: self.amountString ?? "") {
                self.performSegue(withIdentifier: "showReviewTokenSale", sender: nil)
            }
        }
    }

    @IBAction func partcipateInfoTapped(_ sender: Any) {
        DispatchQueue.main.async {
            OzoneAlert.alertDialog(message: TokenSaleStrings.priorityExplanationDialog, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tx = TokenSaleTransactionInfo (
            priorityIncluded: checkboxPriority!.isSelected,
            assetIDUsedToPurchase: selectedAsset?.assetID ?? "",
            assetNameUsedToPurchase: selectedAsset?.name ?? "",
            assetAmount: Double(truncating: amountStringToNumber(amountString: amountString!)!),
            tokenSaleContractHash: saleInfo.scriptHash,
            tokensToRecieveAmount: totalTokens,
            tokensToReceiveName: saleInfo.symbol,
            saleInfo: saleInfo,
            txID: ""
        )
        guard let tokenSaleVC = segue.destination as? TokenSaleReviewTableViewController else {
            return
        }
        tokenSaleVC.logoURL = saleInfo.imageURL
        tokenSaleVC.transactionInfo = tx
    }

    func setContributionAmount(amountString: String) {
        self.amountString = amountString
        let valid = validateAmount(amountString: amountString)
        if amountString != "" && valid == true {
            participateButton.isEnabled = true
        } else {
            participateButton.isEnabled = false
        }
    }

    func setTokenAmount(totalTokens: Double) {
        self.totalTokens = totalTokens
    }

    func setContributionAsset(asset: TransferableAsset) {
        self.selectedAsset = asset
    }

    func setLocalizedStrings() {
        priorityLabel?.text = TokenSaleStrings.priority
        participateButton.setTitle(TokenSaleStrings.review, for: UIControlState())
    }
}
