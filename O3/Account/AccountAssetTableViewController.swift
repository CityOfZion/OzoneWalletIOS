//
//  AccountAssetTableViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit
import NeoSwift
import PKHUD
import Cache
import SwiftTheme
import Crashlytics
import StoreKit

class AccountAssetTableViewController: UITableViewController {
    @IBOutlet weak var addNEP5Button: UIButton!

    private enum sections: Int {
        case unclaimedGAS = 0
        case nativeAssets
        case nep5Tokens
    }

    var selectedNEP5Tokens: [String: NEP5Token] = [:]
    var claims: Claims?
    var isClaiming: Bool = false

    var neoBalance: Int?
    var gasBalance: Double?
    var refreshClaimableGasTimer: Timer?

    var storage: Storage?
    var tokensCache = [NEP5Token: Decimal]()
    var cachedNEOBalance: Int = 0
    var cachedGASBalance: Double = 0.0
    var mostRecentClaimAmount = 0.0

    func initiateCache() {
        if let storage =  try? Storage(diskConfig: DiskConfig(name: "O3")) {
            tokensCache = (try? storage.object(ofType: [NEP5Token: Decimal].self, forKey: "tokenBalances")) ?? [:]
            cachedNEOBalance = (try? storage.object(ofType: Int.self, forKey: "neoBalance")) ?? 0
            cachedGASBalance = (try? storage.object(ofType: Double.self, forKey: "gasBalance")) ?? 0.0
        }
    }

    @objc func reloadCells() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNEP5TokensSection), name: NSNotification.Name(rawValue: "tokenSelectorDismissed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadCells), name: NSNotification.Name(rawValue: ThemeUpdateNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: ThemeUpdateNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "tokenSelectiorDismissed"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        addObservers()
        self.view.theme_backgroundColor = O3Theme.backgroundColorPicker
        self.tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        applyNavBarTheme()
        initiateCache()
        loadSelectedNEP5Tokens()
        loadClaimableGAS()
        loadAccountState()
        refreshClaimableGasTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(AccountAssetTableViewController.loadClaimableGAS), userInfo: nil, repeats: true)
        refreshClaimableGasTimer?.fire()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadAllData), for: .valueChanged)
    }

    func updateTokenCache() {
        try? storage?.setObject(tokensCache, forKey: "tokenBalances")
    }

    @objc func reloadAllData() {
        loadAccountState()
        loadClaimableGAS()
        self.tableView.reloadData()
    }

    @objc func reloadNEP5TokensSection() {
        self.loadSelectedNEP5Tokens()
        tableView.reloadSections(IndexSet(integer: sections.nep5Tokens.rawValue), with: .automatic)
    }

    func claimGas() {
        self.enableClaimButton(enable: false)
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
            Answers.logCustomEvent(withName: "Gas Claimed",
                             customAttributes: ["Amount": self.mostRecentClaimAmount])
            DispatchQueue.main.async {
                //HUD something to notify user that claim succeeded
                //done claiming
                HUD.hide()

                DispatchQueue.main.async {
                    OzoneAlert.alertDialog(message: AccountStrings.successfulClaimPrompt, dismissTitle: OzoneAlert.okPositiveConfirmString) {
                        UserDefaultsManager.numClaims += 1
                        if UserDefaultsManager.numClaims == 1 || UserDefaultsManager.numClaims % 10 == 0 {
                            SKStoreReviewController.requestReview()
                        }
                    }
                }

                //save latest claim time interval here to limit user to only claim every 5 minutes
                let now = Date().timeIntervalSince1970
                UserDefaults.standard.set(now, forKey: "lastetClaimDate")
                UserDefaults.standard.synchronize()

                self.isClaiming = false
                //if claim succeeded then fire the timer to refresh claimable gas again.
                self.refreshClaimableGasTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(AccountAssetTableViewController.loadClaimableGAS), userInfo: nil, repeats: true)
                self.refreshClaimableGasTimer?.fire()

                self.loadClaimableGAS()

            }
        }
    }

    func enableClaimButton(enable: Bool) {
        let indexPath = IndexPath(row: 0, section: sections.unclaimedGAS.rawValue)
        guard let cell = tableView.cellForRow(at: indexPath) as? UnclaimedGASTableViewCell else {
            return
        }
        cell.claimButton.isEnabled = enable && isClaiming == false
    }

    func prepareClaimingGAS() {

        if self.neoBalance == nil || self.neoBalance == 0 {
            return
        }
        refreshClaimableGasTimer?.invalidate()
        //disable the button after tapped
        enableClaimButton(enable: false)

        HUD.show(.labeledProgress(title: AccountStrings.claimingInProgressTitle, subtitle: AccountStrings.claimingInProgressSubtitle))

        //select best node
        if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
            UserDefaultsManager.seed = bestNode
            UserDefaultsManager.useDefaultSeed = false
        }

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
                HUD.hide()
                //HUD or something
                //in case it's error we then enable the button again.
                self.enableClaimButton(enable: true)
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

    @objc func loadClaimableGAS() {
        if Authenticated.account == nil {
            return
        }

        Authenticated.account?.neoClient.getClaims(address: (Authenticated.account?.address)!) { result in
            switch result {
            case .failure:
                return
            case .success(let claims):
                self.claims = claims
                self.mostRecentClaimAmount = Double(claims.totalUnspentClaim) / 100000000.0
                DispatchQueue.main.async {
                    self.showClaimableGASAmount(amount: self.mostRecentClaimAmount)
                }
            }
        }
    }

    func showClaimableGASAmount(amount: Double) {
        DispatchQueue.main.async {

            let indexPath = IndexPath(row: 0, section: sections.unclaimedGAS.rawValue)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? UnclaimedGASTableViewCell else {
                return
            }
            cell.amountLabel.text = amount.string(8, removeTrailing: true)

            //only enable button if latestClaimDate is more than 5 minutes
            let latestClaimDateInterval: Double = UserDefaults.standard.double(forKey: "lastetClaimDate")
            let latestClaimDate: Date = Date(timeIntervalSince1970: latestClaimDateInterval)
            let diff = Date().timeIntervalSince(latestClaimDate)
            if diff > (5 * 60) {
                cell.claimButton.isEnabled = true
            } else {
                cell.claimButton.isEnabled = false
            }

            //amount needs to be more than zero
            cell.claimButton.isEnabled = amount > 0
        }
    }

    func showAccountState(accountState: AccountState?) {
        guard let cellNEO = tableView.cellForRow(at: IndexPath(row: 0, section: sections.nativeAssets.rawValue)) as? NativeAssetTableViewCell else {
            return
        }

        guard let cellGAS = tableView.cellForRow(at: IndexPath(row: 1, section: sections.nativeAssets.rawValue)) as? NativeAssetTableViewCell else {
            return
        }

        guard let accountState = accountState else {
            cellNEO.amountLabel.text = String(format: "%ld", Int(cachedNEOBalance))
            cellGAS.amountLabel.text = String(format: "%.8f", Double(cachedGASBalance))
            return
        }

        DispatchQueue.main.async {
            for asset in accountState.balances {
                if asset.id.contains(NeoSwift.AssetId.neoAssetId.rawValue) {
                    self.neoBalance =  Int(asset.value) ?? 0
                    self.cachedNEOBalance = self.neoBalance ?? 0
                    cellNEO.amountLabel.text = String(format: "%ld", Int(asset.value) ?? 0)
                } else if asset.id.contains(NeoSwift.AssetId.gasAssetId.rawValue) {
                    self.gasBalance = Double(asset.value) ?? 0.0
                    self.cachedGASBalance = self.gasBalance ?? 0.0
                    cellGAS.amountLabel.text = String(format: "%.8f", Double(asset.value) ?? 0.0)
                }
            }

        }
    }

    func loadAccountState() {
        NeoClient(seed: UserDefaultsManager.seed).getAccountState(for: Authenticated.account?.address ?? "") { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.showAccountState(accountState: nil)
                    return
                }
            case .success(let accountState):
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.showAccountState(accountState: accountState)
                }
            }
        }
    }

    func loadSelectedNEP5Tokens() {
        self.selectedNEP5Tokens = UserDefaultsManager.selectedNEP5Token!
    }

    @IBAction func addNEP5TokensTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "addTokens", sender: nil)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        //UNCLAIM GAS, NATIVE ASSETS and NEP5 TOKENS.
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sections.unclaimedGAS.rawValue {
            return 1
        }

        if section == sections.nativeAssets.rawValue {
            return 2
        }

        if section == sections.nep5Tokens.rawValue {
            return selectedNEP5Tokens.count
        }

        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == sections.unclaimedGAS.rawValue {
            return 108.0
        }

        if indexPath.section == sections.nativeAssets.rawValue {
            return 52.0
        }

        if indexPath.section == sections.nep5Tokens.rawValue {
            return 52.0
        }
        return 52.0
    }

    func loadTokenBalance(cell: NEP5TokenTableViewCell, token: NEP5Token) {
        guard let address =  Authenticated.account?.address else {
            return
        }

        NeoClient(seed: UserDefaultsManager.seed).getTokenBalanceUInt(token.tokenHash, address: address) { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    cell.loadingView?.stopAnimating()
                    if let cachedBalance = self.tokensCache[token] {
                        cell.amountLabel.text = cachedBalance.formattedBalance(decimals: token.decimal)
                    }
                }
                return
            case .success(let balance):
                DispatchQueue.main.async {
                    cell.loadingView?.stopAnimating()
                    self.tokensCache[token] = Decimal(balance)
                    self.updateTokenCache()
                    cell.amountLabel.text = Decimal(balance).formattedBalance(decimals: token.decimal)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == sections.unclaimedGAS.rawValue {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell-unclaimedgas") as? UnclaimedGASTableViewCell else {
                let cell =  UITableViewCell()
                cell.theme_backgroundColor = O3Theme.backgroundColorPicker
                return cell
            }
            cell.delegate = self
            return cell
        }

        if indexPath.section == sections.nativeAssets.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell-nativeasset") as? NativeAssetTableViewCell else {
                let cell =  UITableViewCell()
                cell.theme_backgroundColor = O3Theme.backgroundColorPicker
                return cell
            }

            //NEO
            if indexPath.row == 0 {
                cell.titleLabel.text = "NEO"
                //load neo balance here
            }

            //GAS
            if indexPath.row == 1 {
                cell.titleLabel.text = "GAS"
            }

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell-nep5token") as? NEP5TokenTableViewCell else {
            let cell =  UITableViewCell()
            cell.theme_backgroundColor = O3Theme.backgroundColorPicker
            return cell
        }
        let list = Array(selectedNEP5Tokens.values)
        let token = list[indexPath.row]
        cell.titleLabel.text = token.symbol
        cell.subtitleLabel.text = token.name
        DispatchQueue.global().async {
            self.loadTokenBalance(cell: cell, token: token)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {

        if indexPath.section == sections.unclaimedGAS.rawValue {
            return false
        }
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func setLocalizedStrings() {
        self.navigationController?.navigationBar.topItem?.title = AccountStrings.accountTitle
        addNEP5Button.setTitle(AccountStrings.addNEP5Token, for: UIControlState())
    }
}

extension AccountAssetTableViewController: UnclaimGASDelegate {
    func claimButtonTapped() {
        DispatchQueue.main.async {
            self.prepareClaimingGAS()
        }
    }
}
