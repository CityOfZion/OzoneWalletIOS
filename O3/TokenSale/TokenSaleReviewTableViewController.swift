//
//  TokenSaleReviewTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 4/13/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import NeoSwift
import WebBrowser

class TokenSaleReviewTableViewController: UITableViewController {

    @IBOutlet weak var participateButton: ShadowedButton!
    @IBOutlet weak var assetToSendLabel: UILabel!
    @IBOutlet weak var assetToRecieveLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sendTitleLabel: UILabel!
    @IBOutlet weak var receiveTitleLabel: UILabel!

    @IBOutlet weak var notWhitelistedContainer: UIView!
    @IBOutlet weak var notWhitelistedLabel: UILabel!
    @IBOutlet weak var tokenSaleWebsiteButton: UIButton!

    @IBOutlet weak var readSaleAgreementLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(readSaleAgreementTapped(_:)))
            readSaleAgreementLabel?.addGestureRecognizer(tap)
        }
    }

    @IBOutlet weak var iUnderstandLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(iUnderStandTapped(_:)))
            iUnderstandLabel?.addGestureRecognizer(tap)
        }
    }

    @objc @IBAction func readSaleAgreementTapped(_ sender: Any) {
        checkBoxIssuer!.isSelected = !checkBoxIssuer!.isSelected
        participateButton.isEnabled = checkBoxO3!.isSelected && checkBoxIssuer!.isSelected
    }

    @objc @IBAction  func iUnderStandTapped(_ sender: Any) {
        checkBoxO3!.isSelected = !checkBoxO3!.isSelected
        participateButton.isEnabled = checkBoxO3!.isSelected && checkBoxIssuer!.isSelected
    }

    @IBOutlet var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var checkBoxO3: UIButton?
    @IBOutlet var checkBoxIssuer: UIButton?

    var transactionInfo: TokenSaleTableViewController.TokenSaleTransactionInfo!
    var logoURL: String = ""

    func setThemedElements() {
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        sendTitleLabel.theme_textColor = O3Theme.titleColorPicker
        receiveTitleLabel.theme_textColor = O3Theme.titleColorPicker
        notWhitelistedContainer.theme_backgroundColor = O3Theme.backgroundColorPicker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        setThemedElements()

        if transactionInfo.saleInfo.allowToParticipate == false {
             let message = String(format: TokenSaleStrings.notWhiteListedError, transactionInfo.saleInfo.name)
            notWhitelistedLabel.text = message
            notWhitelistedContainer.isHidden = false
        } else {
            notWhitelistedContainer.isHidden = true
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "external-link-alt"), style: .plain, target: self, action: #selector(externalLinkTapped(_:)))

        //disabled until check two checkboxes
        participateButton.isEnabled = false
        logoImageView.kf.setImage(with: URL(string: logoURL))

        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.numberStyle = .decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true

        if transactionInfo.assetNameUsedToPurchase.lowercased() == TransferableAsset.GAS().name.lowercased() {
            amountFormatter.maximumFractionDigits = 8
        }

        if transactionInfo.priorityIncluded == false {
            priorityLabel.isHidden = true
            topSpaceConstraint.constant = -8
        }

        assetToSendLabel.text = String(format: "%@ %@", amountFormatter.string(from: NSNumber(value: transactionInfo.assetAmount))!, transactionInfo.assetNameUsedToPurchase)

        assetToRecieveLabel.text = String(format: "%@ %@", amountFormatter.string(from: NSNumber(value: transactionInfo.tokensToRecieveAmount))!, transactionInfo.tokensToReceiveName)
    }

    @objc func externalLinkTapped(_ sender: Any) {
        let webBrowserViewController = WebBrowserViewController()
        webBrowserViewController.isToolbarHidden = false
        webBrowserViewController.title = transactionInfo.saleInfo.name
        webBrowserViewController.isShowURLInNavigationBarWhenLoading = true
        webBrowserViewController.barTintColor = UserDefaultsManager.themeIndex == 0 ? Theme.light.backgroundColor: Theme.dark.backgroundColor
        webBrowserViewController.tintColor = Theme.light.primaryColor
        webBrowserViewController.isShowPageTitleInNavigationBar = true
        webBrowserViewController.loadURLString(transactionInfo.saleInfo.webURL)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(webBrowserViewController, animated: true)
        }
    }

    @IBAction func tokenSaleWebsiteTapped(_ sender: Any) {
        let webBrowserViewController = WebBrowserViewController()
        webBrowserViewController.isToolbarHidden = false
        webBrowserViewController.title = transactionInfo.saleInfo.name
        webBrowserViewController.isShowURLInNavigationBarWhenLoading = true
        webBrowserViewController.barTintColor = UserDefaultsManager.themeIndex == 0 ? Theme.light.backgroundColor: Theme.dark.backgroundColor
        webBrowserViewController.tintColor = Theme.light.primaryColor
        webBrowserViewController.isShowPageTitleInNavigationBar = true
        webBrowserViewController.loadURLString(transactionInfo.saleInfo.webURL)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(webBrowserViewController, animated: true)
        }
    }

    @IBAction func partcipateTapped(_ sender: Any) {
        if checkBoxO3!.isSelected && checkBoxIssuer!.isSelected {
            //ask for authentication
            //if authenticated then call "submit"
            self.performSegue(withIdentifier: "submit", sender: transactionInfo)
        } else {
            OzoneAlert.alertDialog(message: TokenSaleStrings.pleaseAgreeError, dismissTitle: OzoneAlert.okPositiveConfirmString) { }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submit" {
            if let vc = segue.destination as? TokenSaleSubmitViewController {
                vc.transactionInfo = sender as? TokenSaleTableViewController.TokenSaleTransactionInfo
            }
        }
    }

    func setLocalizedStrings() {
        sendTitleLabel.text = TokenSaleStrings.sendTitle
        priorityLabel.text = TokenSaleStrings.priorityReview
        receiveTitleLabel.text = TokenSaleStrings.youWillReceiveTitle
        readSaleAgreementLabel.text = TokenSaleStrings.readSaleAgreement
        iUnderstandLabel.text = TokenSaleStrings.o3Agreement
        participateButton.setTitle(TokenSaleStrings.participate, for: UIControlState())
        tokenSaleWebsiteButton.setTitle(TokenSaleStrings.tokenSalesTitle, for: UIControlState())
    }

}
