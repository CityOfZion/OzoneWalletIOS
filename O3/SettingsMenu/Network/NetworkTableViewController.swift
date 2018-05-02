//
//  NetworkTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 10/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift
import Crashlytics

class NetworkTableViewController: UITableViewController, NetworkSeedCellDelegate {
    var testNodes = (NEONetworkMonitor.sharedInstance.network?.testNet.nodes)!
    var mainNodes = (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes)!
    var tableNodes: [NEONode] {
        return UserDefaultsManager.network == .main ? mainNodes : testNodes
    }

    func highestBlockCount() -> UInt {
        return tableNodes.map {$0.blockCount}.max() ?? 0
    }

    func updateNodeData() {
        let group = DispatchGroup()
        for node in tableNodes {
            group.enter()
            NeoClient(seed: node.URL).getBlockCount { result in
                switch result {
                case .failure:
                    group.leave()
                case .success(let count):
                    node.blockCount = UInt(count)
                    NeoClient(seed: node.URL).getConnectionCount { result in
                        switch result {
                        case .failure:
                            group.leave()
                        case .success(let count):
                            node.peerCount = UInt(count)
                            DispatchQueue.main.async { self.tableView.reloadData() }
                            group.leave()
                        }
                    }
                }
            }
        }

        group.notify(queue: .main) {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        navigationItem.title = SettingsStrings.networkTitle
        updateNodeData()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNodes.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "networkSeedCell") as? NetworkSeedCell else {
            fatalError("Undefined cell behavior")
        }
        cell.selectionStyle = .none
        cell.delegate = self
        cell.node = tableNodes[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         OzoneAlert.confirmDialog(message: SettingsStrings.networkSwitchWarning, cancelTitle: OzoneAlert.cancelNegativeConfirmString, confirmTitle: OzoneAlert.confirmPositiveConfirmString, didCancel: {}) {

            Answers.logCustomEvent(withName: "Network Node Set",
                                   customAttributes: ["Network Node": self.tableNodes[indexPath.row].URL])

            UserDefaultsManager.seed = self.tableNodes[indexPath.row].URL
            UserDefaultsManager.useDefaultSeed = false
            DispatchQueue.main.async { tableView.reloadData() }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67.5
    }
}
