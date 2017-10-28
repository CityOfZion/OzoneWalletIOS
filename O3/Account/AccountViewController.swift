//
//  AccountViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/11/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift
import DeckTransition

class AccountViewController: ThemedViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var assetCollectionView: UICollectionView!
    @IBOutlet weak var claimButon: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var myAddressButton: UIButton!
    @IBOutlet weak var actionBarView: UIView!

    var transactionHistory = [TransactionHistoryEntry]()
    var neoBalance: Int?
    var gasBalance: Double?
    var assets: Assets?
    var selectedTransactionID: String!
    var refreshClaimableGasTimer: Timer?
    var claims: Claims?
    var isClaiming: Bool = false

    func addThemedElements() {
        themedTableViews = [historyTableView]
        themedCollectionViews = [assetCollectionView]
        themedTransparentButtons = [claimButon, sendButton, myAddressButton]
    }

    @objc func loadNeoData() {
        Neo.client.getTransactionHistory(for: Authenticated.account?.address ?? "") { result in
            switch result {
            case .failure:
                return
            case .success(let txHistory):
                self.transactionHistory = txHistory.entries
                DispatchQueue.main.async { self.historyTableView.reloadData() }
            }
        }

        Neo.client.getAccountState(for: Authenticated.account?.address ?? "") { result in
            switch result {
            case .failure:
                return
            case .success(let accountState):
                for asset in accountState.balances {
                    if asset.id.contains(NeoSwift.AssetId.neoAssetId.rawValue) {
                        self.neoBalance = Int(asset.value) ?? 0
                    } else if asset.id.contains(NeoSwift.AssetId.gasAssetId.rawValue) {
                        self.gasBalance = Double(asset.value) ?? 0
                    }
                }
                DispatchQueue.main.async {
                    self.assetCollectionView.delegate = self
                    self.assetCollectionView.dataSource = self
                    self.assetCollectionView.reloadData()
                    self.historyTableView.refreshControl?.endRefreshing()
                }
            }
        }
    }

    func showClaimableGASInButton(amount: Double) {
        let gasAmountString = String(format:"%.8f", amount)
        let text = String(format:"Claim\n%@", gasAmountString)
        let attributedString = NSMutableAttributedString(string: text)

        let nsText = text as NSString
        let gasAmountRange = nsText.range(of: "\n" + gasAmountString)
        let titleRange = nsText.range(of: "Claim")
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UserDefaultsManager.theme.textColor, range: gasAmountRange)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UserDefaultsManager.theme.primaryColor, range: titleRange)
        claimButon?.setAttributedTitle(attributedString, for: .normal)

        let attributedStringDisabled = NSMutableAttributedString(string: text)

        attributedStringDisabled.addAttribute(NSAttributedStringKey.foregroundColor, value: UserDefaultsManager.theme.disabledColor, range: gasAmountRange)
        attributedStringDisabled.addAttribute(NSAttributedStringKey.foregroundColor, value: UserDefaultsManager.theme.disabledColor, range: titleRange)
        claimButon?.setAttributedTitle(attributedStringDisabled, for: .disabled)
    }

    @objc func loadClaimableGAS() {
        if Authenticated.account == nil {
            return
        }

        Neo.client.getClaims(address: (Authenticated.account?.address)!) { result in
            switch result {
            case .failure:
                return
            case .success(let claims):
                self.claims = claims
                let amount: Double = Double(claims.totalUnspentClaim) / 100000000.0
                DispatchQueue.main.async {
                    self.showClaimableGASInButton(amount: amount)
                    //only enable button if latestClaimDate is more than 5 minutes
                    let latestClaimDateInterval: Double = UserDefaults.standard.double(forKey: "lastetClaimDate")
                    let latestClaimDate: Date = Date(timeIntervalSince1970: latestClaimDateInterval)
                    let diff = Date().timeIntervalSince(latestClaimDate)
                    if diff > (5 * 60) {
                        self.claimButon?.isEnabled = true
                    } else {
                        self.claimButon?.isEnabled = false
                    }

                   self.claimButon?.isEnabled = amount > 0
                }
            }
        }
    }

    override func viewDidLoad() {
        addThemedElements()
        super.viewDidLoad()
        self.navigationController?.hideHairline()
        self.navigationItem.largeTitleDisplayMode = .automatic
        historyTableView.delegate = self
        historyTableView.dataSource = self
        loadNeoData()
        refreshClaimableGasTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(AccountViewController.loadClaimableGAS), userInfo: nil, repeats: true)
        refreshClaimableGasTimer?.fire()

        self.historyTableView.refreshControl = UIRefreshControl()
        self.historyTableView.refreshControl?.addTarget(self, action: #selector(loadNeoData), for: .valueChanged)
        actionBarView!.backgroundColor = UserDefaultsManager.theme.borderColor
    }

    override func changedTheme(_ sender: Any) {
        super.changedTheme(sender)
        DispatchQueue.main.async {
            self.actionBarView!.backgroundColor = UserDefaultsManager.theme.borderColor
            self.assetCollectionView.reloadData()
        }
    }

    @IBAction func sendTapped(_ sender: Any) {
        //self.performSegue(withIdentifier: "segueToSend", sender: nil)
        let modal = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendTableViewController")
        let nav = WalletHomeNavigationController(rootViewController: modal)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .automatic
        modal.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "times"), style: .plain, target: self, action: #selector(tappedLeftBarButtonItem(_:)))
        let transitionDelegate = DeckTransitioningDelegate()
        nav.transitioningDelegate = transitionDelegate
        nav.modalPresentationStyle = .custom
        present(nav, animated: true, completion: nil)
    }

    @IBAction func myAddressTapped(_ sender: Any) {
        //Couldn't get storyboard to work with this DeckTransition
        //self.performSegue(withIdentifier: "myAddress", sender: nil)
        let modal = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MyAddressNavigationController")

        let transitionDelegate = DeckTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWebview" {
            guard let dest = segue.destination as? TransactionWebViewController else {
                fatalError("Undefined Segue behavior")
            }
            dest.transactionID = selectedTransactionID
        }
    }

    @objc func claimGas() {
        self.refreshClaimableGasTimer?.invalidate()
        self.claimButon?.isEnabled = false
        //refresh the amount of claimable gas
        self.loadClaimableGAS()
        Authenticated.account?.claimGas { _, error in
            if error != nil {
                //if error then try again in 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.claimGas()
                }
                return
            }

            DispatchQueue.main.async {
                //HUD something to notify user that claim succeeded
                //done claiming
                O3HUD.stop {
                    DispatchQueue.main.async {
                        OzoneAlert.alertDialog(message: "Your claim has succeeded, it may take a few minutes to be reflected in your transaction history", dismissTitle: "Ok") { }
                    }
                    self.isClaiming = false
                    //if claim succeeded then fire the timer to refresh claimable gas again.
                    self.refreshClaimableGasTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(AccountViewController.loadClaimableGAS), userInfo: nil, repeats: true)
                    self.refreshClaimableGasTimer?.fire()
                    self.loadNeoData()
                    self.loadClaimableGAS()
                }
            }
        }
    }
    @IBAction func claimTapped(_ sender: Any) {
        let now = Date().timeIntervalSince1970
        O3HUD.start()
        //save latest claim time interval here to limit user to only claim every 5 minutes
        UserDefaults.standard.set(now, forKey: "lastetClaimDate")
        UserDefaults.standard.synchronize()

        //disable the button after tapped
        self.claimButon?.isEnabled = false
        //we are able to claim gas only when there is data in the .claims array
        if self.claims != nil && self.claims!.claims.count > 0 {
            DispatchQueue.main.async {
                self.claimGas()
            }
            return
        }
        //to be able to claim. we need to send the entire NEO to ourself.
        Authenticated.account?.sendAssetTransaction(asset: AssetId.neoAssetId, amount: Double(self.neoBalance!), toAddress: (Authenticated.account?.address)!) { completed, _ in
            if completed == false {
                O3HUD.stop {}
                //HUD or something
                //in case it's error we then enable the button again.
                self.claimButon?.isEnabled = true
                return
            }
            DispatchQueue.main.async {
                //if completed then mark the flag that we are claiming GAS
                self.isClaiming = true
                //disable button and invalidate the timer to refresh claimable GAS
                self.refreshClaimableGasTimer?.invalidate()

                //try to claim gas after 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.claimGas()
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {

        //DEFINITELY NEED A BETTER STRUCT TO MANaGE TRANSACTION HISTORIES
        case historyTableView:
            let transactionEntry = transactionHistory[indexPath.row]
            let isNeoTransaction = transactionEntry.gas == 0 ? true : false
            var transactionData: TransactionCell.TransactionData?
            if isNeoTransaction {
                transactionData = TransactionCell.TransactionData(type: TransactionCell.TransactionType.send, date: transactionEntry.blockIndex,
                                                                  asset: "Neo", address: transactionEntry.transactionID, amount: Double(transactionEntry.neo), precision: 0)
            } else {
                transactionData = TransactionCell.TransactionData(type: TransactionCell.TransactionType.send, date: transactionEntry.blockIndex,
                                                                  asset: "Gas", address: transactionEntry.transactionID, amount: transactionEntry.gas, precision: 8)
            }
            let transactionCellData = transactionData!
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell else {
                fatalError("Undefined table view behavior")
            }
            cell.data = transactionCellData
            return cell
        default: fatalError("Undefined table view behavior")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case historyTableView:

            selectedTransactionID  = transactionHistory[indexPath.row].transactionID
            self.performSegue(withIdentifier: "segueToWebview", sender: nil)

        default: fatalError("undefined table view behavior")

        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {

        case historyTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionsHeaderCell") as? TransactionsHeaderCell else {
                fatalError("undefined table view behavior")
            }
            return cell
        default: fatalError("undefined table view behavior")
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case historyTableView:
            return 44
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {

        case historyTableView:
            return transactionHistory.count
        default: return 0
        }
    }

    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {
    }

}

extension AccountViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.6, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let assetData = AssetCollectionViewCell.AssetData(assetName: "NEO", assetAmount: Double(neoBalance ?? 0), precision: 0)

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountAssetCell", for: indexPath) as? AssetCollectionViewCell else {
                fatalError("undefined table view behavior")
            }
            cell.data = assetData
            cell.assetBackgroundView.backgroundColor = UserDefaultsManager.theme.cardColor
            return cell
        case 1:
            let assetData = AssetCollectionViewCell.AssetData(assetName: "GAS", assetAmount: Double(gasBalance ?? 0), precision: 8)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountAssetCell", for: indexPath) as? AssetCollectionViewCell else {
                fatalError("undefined table view behavior")
            }
            cell.data = assetData
            cell.assetBackgroundView.backgroundColor = UserDefaultsManager.theme.cardColor
            return cell
        default: fatalError("undefined table view behavior")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let assetDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssetDetailViewController") as? AssetDetailViewController {
            switch indexPath.row {
            case 0:
                assetDetailViewController.selectedAsset = "neo"
            case 1:
                assetDetailViewController.selectedAsset = "gas"

            default: fatalError("undefined collectionView behavior")
            }
            let nav = WalletHomeNavigationController(rootViewController: assetDetailViewController)
            nav.navigationBar.prefersLargeTitles = true
            nav.navigationItem.largeTitleDisplayMode = .automatic
            assetDetailViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "times"), style: .plain, target: self, action: #selector(tappedLeftBarButtonItem(_:)))

            let transitionDelegate = DeckTransitioningDelegate()
            nav.transitioningDelegate = transitionDelegate
            nav.modalPresentationStyle = .custom
            present(nav, animated: true, completion: nil)
        }

    }

    @IBAction func tappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
