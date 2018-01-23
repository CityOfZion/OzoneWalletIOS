//
//  AssetSelectorTableViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/23/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import NeoSwift

protocol AssetSelectorDelegate {
    func assetSelected(selected: TransferableAsset)
}

class AssetSelectorTableViewController: ThemedTableViewController {

    var accountState: AccountState!
    var delegate: AssetSelectorDelegate?

    enum sections: Int {
        case nativeAssets = 0
        case nep5Tokens
    }
    var neoBalance: Int?
    var gasBalance: Double?
    var selectedNEP5Tokens: [String: NEP5Token] = [:]

    var assets: [String: TransferableAsset]! = [:]
    var transferableNEO: TransferableAsset! = TransferableAsset(assetID: NeoSwift.AssetId.neoAssetId.rawValue, name: "NEO", symbol: "NEO", assetType: AssetType.NativeAsset, decimal: 0, balance: 0.0)

    var transferableGAS: TransferableAsset! = TransferableAsset(assetID: NeoSwift.AssetId.gasAssetId.rawValue, name: "GAS", symbol: "GAS", assetType: AssetType.NativeAsset, decimal: 0, balance: 0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Select Asset", comment: "")
        selectedNEP5Tokens = UserDefaultsManager.selectedNEP5Token!
        for token in selectedNEP5Tokens {
            let nep5 = token.value
            let a = TransferableAsset(assetID: nep5.tokenHash, name: nep5.name, symbol: nep5.symbol, assetType: AssetType.NEP5Token, decimal: nep5.decimal, balance: 0.0)
            //update max amount from server
            assets[nep5.tokenHash] = a
        }

        self.loadAccountState()
    }

    func showAccountState(accountState: AccountState) {
        guard let cellNEO = tableView.cellForRow(at: IndexPath(row: 0, section: sections.nativeAssets.rawValue)) as? NativeAssetTableViewCell else {
            return
        }

        guard let cellGAS = tableView.cellForRow(at: IndexPath(row: 1, section: sections.nativeAssets.rawValue)) as? NativeAssetTableViewCell else {
            return
        }
        DispatchQueue.main.async {
            for asset in accountState.balances {
                if asset.id.contains(NeoSwift.AssetId.neoAssetId.rawValue) {
                    self.neoBalance =  Int(asset.value) ?? 0
                    cellNEO.amountLabel.text = String(format:"%ld", Int(asset.value) ?? 0)
                    self.transferableNEO.balance = Decimal(self.neoBalance!)
                } else if asset.id.contains(NeoSwift.AssetId.gasAssetId.rawValue) {
                    self.gasBalance = Double(asset.value) ?? 0.0
                    self.transferableGAS.balance = Decimal(self.gasBalance!)
                    cellGAS.amountLabel.text = String(format:"%.8f", Double(asset.value) ?? 0.0)
                }
            }
        }
    }

    func loadAccountState() {
        Neo.client.getAccountState(for: Authenticated.account?.address ?? "") { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sections.nativeAssets.rawValue {
            return 2
        }

        return selectedNEP5Tokens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == sections.nativeAssets.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell-nativeasset") as? NativeAssetTableViewCell else {
                return UITableViewCell()
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
            return UITableViewCell()
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

    func loadTokenBalance(cell: NEP5TokenTableViewCell, token: NEP5Token) {
        guard let address =  Authenticated.account?.address else {
            return
        }

        Neo.client.getTokenBalanceUInt(token.tokenHash, address: address) { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    cell.loadingView?.stopAnimating()
                }
                return
            case .success(let balance):
                DispatchQueue.main.async {
                    cell.loadingView?.stopAnimating()
                    let balanceDecimal = Decimal(balance) / pow(10, token.decimal)
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 0
                    formatter.maximumFractionDigits = token.decimal
                    formatter.numberStyle = .decimal
                    cell.amountLabel.text = formatter.string(for: balanceDecimal)

                    //set max amount for transferableAsset here
                    if self.assets[token.tokenHash] != nil {
                        self.assets[token.tokenHash]?.balance = balanceDecimal
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == sections.nativeAssets.rawValue {
            if indexPath.row == 0 {
                //neo
                delegate?.assetSelected(selected: self.transferableNEO)
            } else if indexPath.row == 1 {
                //gas
                delegate?.assetSelected(selected: self.transferableGAS)
            }
        } else if indexPath.section == sections.nep5Tokens.rawValue {
            let list = Array(selectedNEP5Tokens.values)
            let token = list[indexPath.row]
            if self.assets[token.tokenHash] != nil {
                delegate?.assetSelected(selected: self.assets[token.tokenHash]!)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
