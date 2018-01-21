//
//  AccountAssetTableViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

class AccountAssetTableViewController: UITableViewController {

    private enum sections: Int {
        case unclaimedGAS = 0
        case nativeAssets
        case nep5Tokens
    }

    var selectedNEP5Tokens: [NEP5Token] = []
    //load this remotely later
    var availableNEP5Tokens: [NEP5Token] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadSelectedNEP5Tokens()
    }

    func loadClaimableGas() {

    }

    func loadSelectedNEP5Tokens() {

        let rpx = NEP5Token(tokenHash: "ecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                            name: "Red Pulse Token",
                            symbol: "RPX",
                            decimal: 8,
                            totalSupply: 1358371250)

        selectedNEP5Tokens.append(rpx)

        let dbc = NEP5Token(tokenHash: "b951ecbbc5fe37a9c280a76cb0ce0014827294cf",
                            name: "DeepBrain Coin",
                            symbol: "DBC",
                            decimal: 8,
                            totalSupply: 9580000000)

        selectedNEP5Tokens.append(dbc)

        let rht = NEP5Token(tokenHash: "2328008e6f6c7bd157a342e789389eb034d9cbc4",
                            name: "Redeemable HashPuppy Token",
                            symbol: "RHT",
                            decimal: 0,
                            totalSupply: 60000)
        selectedNEP5Tokens.append(rht)

        let qlc = NEP5Token(tokenHash: "0d821bd7b6d53f5c2b40e217c6defc8bbe896cf5",
                            name: "Qlink Token",
                            symbol: "QLC",
                            decimal: 8,
                            totalSupply: 600000000)
        selectedNEP5Tokens.append(qlc)
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
            return UITableViewAutomaticDimension
        }

        if indexPath.section == sections.nativeAssets.rawValue {
            return 60.0
        }

        if indexPath.section == sections.nep5Tokens.rawValue {
            return 60.0
        }
        return 60.0
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderTableViewCell else {
//                fatalError("undefined table view behavior")
//            }
//
//        if section == sections.nativeAssets.rawValue {
//            cell.titleLabel.text = NSLocalizedString("Native Assets", comment: "")
//        }
//
//        if section == sections.nep5Tokens.rawValue {
//            cell.titleLabel.text = NSLocalizedString("NEP5 Tokens", comment: "")
//        }
//
//            return cell
//    }

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.0
//
//        if section == sections.unclaimedGAS.rawValue {
//            return 0.0
//        }
//
//        if section == sections.nativeAssets.rawValue {
//             return 44.0
//        }
//
//        if section == sections.nep5Tokens.rawValue {
//             return 44.0
//        }
//        return 44.0
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == sections.unclaimedGAS.rawValue {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell-unclaimedgas") as? UnclaimedGASTableViewCell else {
                return UITableViewCell()
            }

            return cell
        }

        if indexPath.section == sections.nativeAssets.rawValue {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell-nativeasset") as? NativeAssetTableViewCell else {
                return UITableViewCell()
            }

            //NEO
            if indexPath.row == 0 {
                cell.titleLabel.text = "NEO"
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
        let token = selectedNEP5Tokens[indexPath.row]
        cell.titleLabel.text = token.symbol
        cell.subtitleLabel.text = token.name
        return cell
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {

        if indexPath.section == sections.unclaimedGAS.rawValue {
            return false
        }
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
