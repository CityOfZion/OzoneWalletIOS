//
//  SendViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/11/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift
import KeychainAccess
import SwiftTheme
import Crashlytics

class SendTableViewController: UITableViewController, AddressSelectDelegate, QRScanDelegate {

    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var toAddressField: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var selectedAssetLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!

    @IBOutlet weak var recipientCell: UITableViewCell!
    @IBOutlet weak var sendAmountCell: UITableViewCell!
    @IBOutlet weak var sendAssetCell: UITableViewCell!

    var gasBalance: Decimal = 0
    var transactionCompleted: Bool!
    var selectedAsset: TransferableAsset?
    var preselectedAddress = ""

    func addThemedElements() {
        let themedTitleLabels = [toLabel, assetLabel, amountLabel]
        for label in themedTitleLabels {
            label?.theme_textColor = O3Theme.titleColorPicker
        }
        recipientCell.contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        sendAmountCell.contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        sendAssetCell.contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        let themedTextFields = [toAddressField, amountField]
        let placeHolderColor = ThemeManager.currentThemeIndex == 0 ? Theme.light.textFieldPlaceHolderColor : Theme.dark.textFieldPlaceHolderColor
        for field in themedTextFields {
            field!.attributedPlaceholder = NSAttributedString(
                string: field!.placeholder ?? "",
                attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor])
            field?.theme_keyboardAppearance = O3Theme.keyboardPicker
            field?.theme_backgroundColor = O3Theme.clearTextFieldBackgroundColorPicker
            field?.theme_textColor = O3Theme.textFieldTextColorPicker
        }
    }

    override func viewDidLoad() {
        addThemedElements()
        applyNavBarTheme()
        setLocalizedStrings()
        super.viewDidLoad()
        //select best node
        DispatchQueue.global().async {
            if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
                UserDefaultsManager.seed = bestNode
                UserDefaultsManager.useDefaultSeed = false
            }
        }

        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        self.enableSendButton()
        self.toAddressField.text = preselectedAddress.trim()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            amountField.becomeFirstResponder()
        }
    }
    func sendNEP5Token(tokenHash: String, assetName: String, amount: Double, toAddress: String) {

        DispatchQueue.main.async {
            OzoneAlert.confirmDialog(message: SendStrings.sendConfirmationPrompt, cancelTitle: OzoneAlert.cancelNegativeConfirmString, confirmTitle: OzoneAlert.confirmPositiveConfirmString, didCancel: {}) {
            let keychain = Keychain(service: "network.o3.neo.wallet")
                do {
                    _ = try keychain
                        .authenticationPrompt(SendStrings.authenticateToSendPrompt)
                        .get("ozonePrivateKey")
                    O3HUD.start()
                    if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
                        UserDefaultsManager.seed = bestNode
                        UserDefaultsManager.useDefaultSeed = false
                    }
                    #if TESTNET
                        UserDefaultsManager.seed = "http://seed2.neo.org:20332"
                        UserDefaultsManager.useDefaultSeed = false
                        UserDefaultsManager.network = .test
                        Authenticated.account?.neoClient = NeoClient(network: .test)
                    #endif
                    Authenticated.account?.sendNep5Token(tokenContractHash: tokenHash, amount: amount, toAddress: toAddress, completion: { (completed, _) in

                        O3HUD.stop {
                            self.transactionCompleted = completed ?? false
                            Answers.logCustomEvent(withName: "Token Asset Sent",
                                                   customAttributes: [
                                                    "Asset Name": assetName,
                                                    "Amount": amount])
                            self.performSegue(withIdentifier: "segueToTransactionComplete", sender: nil)
                        }

                    })

                } catch _ {
                }
            }
        }
    }

    func sendNativeAsset(assetId: AssetId, assetName: String, amount: Double, toAddress: String) {
        DispatchQueue.main.async {
            OzoneAlert.confirmDialog(message: SendStrings.sendConfirmationPrompt, cancelTitle: OzoneAlert.cancelNegativeConfirmString, confirmTitle: OzoneAlert.okPositiveConfirmString, didCancel: {}) {
            let keychain = Keychain(service: "network.o3.neo.wallet")
                do {
                    _ = try keychain
                        .authenticationPrompt(SendStrings.authenticateToSendPrompt)
                        .get("ozonePrivateKey")
                    O3HUD.start()
                    if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
                        UserDefaultsManager.seed = bestNode
                        UserDefaultsManager.useDefaultSeed = false
                    }
                    #if TESTNET
                        UserDefaultsManager.seed = "http://seed2.neo.org:20332"
                        UserDefaultsManager.useDefaultSeed = false
                        UserDefaultsManager.network = .test
                        Authenticated.account?.neoClient = NeoClient(network: .test)
                    #endif
                    Authenticated.account?.sendAssetTransaction(asset: assetId, amount: amount, toAddress: toAddress) { completed, _ in
                        O3HUD.stop {
                            self.transactionCompleted = completed ?? false
                            if self.transactionCompleted {
                                Answers.logCustomEvent(withName: "Native Asset Sent",
                                                       customAttributes: [
                                                        "Asset Name": assetName,
                                                        "Amount": amount])
                            }
                            self.performSegue(withIdentifier: "segueToTransactionComplete", sender: nil)
                        }
                    }
                } catch _ {
                }
            }
        }
    }

    @IBAction func sendButtonTapped() {

        if self.selectedAsset == nil {
            return
        }

        let assetId: String! = self.selectedAsset!.assetID!
        let assetName: String! = self.selectedAsset?.name!
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = self.selectedAsset!.decimal
        amountFormatter.numberStyle = .decimal

        var amount = amountFormatter.number(from: (self.amountField.text?.trim())!)

        if amount == nil {
            OzoneAlert.alertDialog(message: SendStrings.invalidAmountError, dismissTitle: OzoneAlert.okPositiveConfirmString, didDismiss: {
                self.amountField.becomeFirstResponder()
            })
            return
        }

        //validate amount
        if amount!.decimalValue > self.selectedAsset!.balance! {
            let balanceDecimal = self.selectedAsset!.balance
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = self.selectedAsset!.decimal
            formatter.numberStyle = .decimal
            let balanceString = formatter.string(for: balanceDecimal)

            let message = String(format: SendStrings.notEnoughBalanceError, assetName, balanceString!)
            OzoneAlert.alertDialog(message: message, dismissTitle: OzoneAlert.okPositiveConfirmString, didDismiss: {
                self.amountField.becomeFirstResponder()
            })
            return
        } else if selectedAsset?.name.lowercased() == "gas" && self.selectedAsset!.balance! - amount!.decimalValue <= 0.00000001 {
            OzoneAlert.alertDialog(message: SendStrings.roundingGasError, dismissTitle: OzoneAlert.okPositiveConfirmString, didDismiss: {
                    self.amountField.becomeFirstResponder()
            })
            return
        } else if selectedAsset?.assetType == AssetType.nep5Token && gasBalance == 0.0 {
            OzoneAlert.alertDialog(message: SendStrings.notEnoughGasForInvokeError, dismissTitle: OzoneAlert.okPositiveConfirmString, didDismiss: {
                self.amountField.becomeFirstResponder()
            })
            return
        }
        let toAddress = toAddressField.text?.trim() ?? ""

        //validate address first
        if NEOValidator.validateNEOAddress(toAddress) == false {
            DispatchQueue.main.async {
                OzoneAlert.alertDialog(message: SendStrings.invalidAddressError, dismissTitle: OzoneAlert.okPositiveConfirmString, didDismiss: {
                    self.toAddressField.becomeFirstResponder()
                })
                return
            }
        }

        if self.selectedAsset?.assetType == AssetType.nativeAsset {
            self.sendNativeAsset(assetId: NeoSwift.AssetId(rawValue: assetId)!, assetName: assetName, amount: amount!.doubleValue, toAddress: toAddress)
        } else if self.selectedAsset?.assetType == AssetType.nep5Token {
            self.sendNEP5Token(tokenHash: assetId, assetName: assetName, amount: amount!.doubleValue, toAddress: toAddress)
        }
    }

    @IBAction func pasteTapped(_ sender: Any) {
        toAddressField.text = UIPasteboard.general.string
        enableSendButton()
    }

    @IBAction func scanTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToQR", sender: nil)
    }

    func selectedAddress(_ address: String) {
        toAddressField.text = address
        enableSendButton()
    }

    func qrScanned(data: String) {
        toAddressField.text = data
        enableSendButton()
    }

    @IBAction func selectAssetTapped(_ sender: Any) {
        guard let nav = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "AssetSelectorNavigationController") as? UINavigationController else {
            return
        }

        guard let modal = nav.viewControllers.first as? AssetSelectorTableViewController else {
            return
        }
        modal.delegate = self
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: nav)
        nav.modalPresentationStyle = .custom
        nav.transitioningDelegate = self.halfModalTransitioningDelegate
        self.present(nav, animated: true, completion: nil)
    }

    @IBAction func enableSendButton() {
        sendButton.isEnabled = toAddressField.text?.isEmpty == false && amountField.text?.isEmpty == false && selectedAsset != nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddressSelect" {
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
            guard let dest = segue.destination as? UINavigationController,
                let addressSelectVC = dest.childViewControllers[0] as? AddressSelectTableViewController else {
                    fatalError("Undefined Table view behavior")
            }
            addressSelectVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "times"), style: .plain, target: self, action: #selector(tappedCloseAddressSeletor(_:)))
            addressSelectVC.delegate = self
        } else if segue.identifier == "segueToQR" {
            guard let dest = segue.destination as? QRScannerController else {
                fatalError("Undefined segue behavior")
            }
            dest.delegate = self
        } else if segue.identifier == "segueToTransactionComplete" {
            guard let dest = segue.destination as? SendCompleteViewController else {
                fatalError("Undefined segue behavior")
            }
            dest.transactionSucceeded = transactionCompleted
        }
    }

    @IBAction func addressTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueToAddressSelect", sender: nil)
    }

    @IBAction func tappedCloseAddressSeletor(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func setLocalizedStrings() {
        toLabel.text = SendStrings.toLabel
        assetLabel.text = SendStrings.assetLabel
        amountLabel.text = SendStrings.amountLabel
        pasteButton.setTitle(SendStrings.paste, for: UIControlState())
        scanButton.setTitle(SendStrings.scan, for: UIControlState())
        addressButton.setTitle(SendStrings.addressBook, for: UIControlState())
        selectedAssetLabel.text = SendStrings.selectedAssetLabel
        sendButton.setTitle(SendStrings.send, for: UIControlState())
        self.title = SendStrings.send
        toAddressField.placeholder = SendStrings.toAddressPlaceholder
    }
}

extension SendTableViewController: AssetSelectorDelegate {
    func assetSelected(selected: TransferableAsset, gasBalance: Decimal) {
        DispatchQueue.main.async {
            self.gasBalance = gasBalance
            self.selectedAsset = selected
            self.assetLabel.text = selected.assetType == AssetType.nativeAsset ? "Asset" : "NEP5 Token"
            self.selectedAssetLabel.text = selected.symbol
            self.enableSendButton()
        }
    }
}
