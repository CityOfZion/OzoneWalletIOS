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
import Lottie
import KeychainAccess

class SendTableViewController: ThemedTableViewController, AddressSelectDelegate, QRScanDelegate {

    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var toAddressField: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var selectedAssetLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    var transactionCompleted: Bool!
    var selectedAsset: TransferableAsset?

    func addThemedElements() {
        themedTitleLabels = [toLabel, assetLabel, amountLabel, noteLabel]
        themedTextFields = [toAddressField, amountField]
        themedTextViews = [noteTextView]
    }

    override func viewDidLoad() {
        addThemedElements()
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        let networkButton = UIBarButtonItem(title: (Authenticated.account?.neoClient.network.rawValue)! + "Net", style: .plain, target: nil, action: nil)
        networkButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = networkButton
        self.enableSendButton()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            amountField.becomeFirstResponder()
        } else if indexPath.row == 3 {
            noteTextView.becomeFirstResponder()
        }
    }
    func sendNEP5Token(tokenHash: String, assetName: String, amount: Double, toAddress: String) {

        DispatchQueue.main.async {
            let message = "Are you sure you want to send \(amount) \(assetName) to \(toAddress) on the \(Authenticated.account?.neoClient.network.rawValue ?? "Unknown")Net"
            OzoneAlert.confirmDialog(message: message, cancelTitle: "Cancel", confirmTitle: "Confirm", didCancel: {}) {
                let keychain = Keychain(service: "network.o3.neo.wallet")
                DispatchQueue.global().async {
                    do {
                        _ = try keychain
                            .authenticationPrompt("Authenticate to send transaction")
                            .get("ozonePrivateKey")
                        O3HUD.start()
                        if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
                            UserDefaultsManager.seed = bestNode
                            UserDefaultsManager.useDefaultSeed = false
                        }
                        Authenticated.account?.sendNep5Token(tokenContractHash: tokenHash, amount: amount, toAddress: toAddress, completion: { (completed, _) in

                            O3HUD.stop {
                                self.transactionCompleted = completed ?? false
                                self.performSegue(withIdentifier: "segueToTransactionComplete", sender: nil)
                            }

                        })

                    } catch _ {
                    }
                }
            }
        }

    }

    func sendNativeAsset(assetId: AssetId, assetName: String, amount: Double, toAddress: String) {
        DispatchQueue.main.async {
            let message = "Are you sure you want to send \(amount) \(assetName) to \(toAddress) on the \(Authenticated.account?.neoClient.network.rawValue ?? "Unknown")Net"
            OzoneAlert.confirmDialog(message: message, cancelTitle: "Cancel", confirmTitle: "Confirm", didCancel: {}) {
                let keychain = Keychain(service: "network.o3.neo.wallet")
                DispatchQueue.global().async {
                    do {
                        _ = try keychain
                            .authenticationPrompt("Authenticate to send transaction")
                            .get("ozonePrivateKey")
                        O3HUD.start()
                        if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
                            UserDefaultsManager.seed = bestNode
                            UserDefaultsManager.useDefaultSeed = false
                        }
                        Authenticated.account?.sendAssetTransaction(asset: assetId, amount: amount, toAddress: toAddress) { completed, _ in
                            O3HUD.stop {
                                self.transactionCompleted = completed ?? false
                                self.performSegue(withIdentifier: "segueToTransactionComplete", sender: nil)
                            }
                        }
                    } catch _ {
                    }
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
        var amount = Double(amountField.text ?? "") ?? 0
        if self.selectedAsset?.decimal == 0 {
            amount.round()
        }

        //validate amount

        if Decimal(amount) > self.selectedAsset!.balance! {

            let balanceDecimal = self.selectedAsset!.balance / pow(10, self.selectedAsset!.decimal)
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = self.selectedAsset!.decimal
            formatter.numberStyle = .decimal
            let balanceString = formatter.string(for: balanceDecimal)

            let message = String(format:"You don't have enough %@. Your balance is %@", assetName, balanceString!)
            OzoneAlert.alertDialog(message: message, dismissTitle: "OK", didDismiss: {
                self.amountField.becomeFirstResponder()
            })
            return
        }
        let toAddress = toAddressField.text?.trim() ?? ""

        //validate address first
        toAddress.validNEOAddress { (valid) in
            if valid == false {
                DispatchQueue.main.async {
                    OzoneAlert.alertDialog(message: "Invalid Address", dismissTitle: "OK", didDismiss: {
                        self.toAddressField.becomeFirstResponder()
                    })
                    return
                }
            }

            if self.selectedAsset?.assetType == AssetType.NativeAsset {
                self.sendNativeAsset(assetId: NeoSwift.AssetId(rawValue: assetId)!, assetName: assetName, amount: amount, toAddress: toAddress)
            } else if self.selectedAsset?.assetType == AssetType.NEP5Token {
                self.sendNEP5Token(tokenHash: assetId, assetName: assetName, amount: amount, toAddress: toAddress)
            }

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

}

extension SendTableViewController: AssetSelectorDelegate {
    func assetSelected(selected: TransferableAsset) {
        DispatchQueue.main.async {
            self.selectedAsset = selected
            self.assetLabel.text = selected.assetType == AssetType.NativeAsset ? "Asset" : "NEP5 Token"
            self.selectedAssetLabel.text = selected.symbol
            self.enableSendButton()
        }
    }
}
