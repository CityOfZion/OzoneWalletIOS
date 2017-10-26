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

class NetworkTableViewController: ThemedTableViewController, NetworkSeedCellDelegate {
    var testNodes = (NEONetworkMonitor.sharedInstance.network?.testNet.nodes)!
    var mainNodes = (NEONetworkMonitor.sharedInstance.network?.mainNet.nodes)!
    var tableNodes: [NEONode] {
        return UserDefaultsManager.network == .main ? mainNodes : testNodes
    }

    func highestBlockCount() -> UInt {
        return tableNodes.map {$0.blockCount}.max() ?? 0
    }

    func updateNodeData() {
        O3HUD.start()
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
                            group.leave()
                        }
                    }
                }
            }
        }

        group.notify(queue: .main) {
            O3HUD.stop {
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Network"
        updateNodeData()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return tableNodes.count
        default: fatalError("Undefined table section behavior")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "networkTypeCell") as? NetworkTypeCell else {
                fatalError("Undefined cell behavior")
            }
            cell.delegate = self
            cell.networkTypeButton.setTitle(UserDefaultsManager.network.rawValue, for: UIControlState())
            cell.seedTypeButton.setTitle(UserDefaultsManager.useDefaultSeed == true ? "Default": "Custom", for: UIControlState())
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "networkSeedCell") as? NetworkSeedCell else {
                fatalError("Undefined cell behavior")
            }
            cell.delegate = self
            cell.node = tableNodes[indexPath.row]
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            OzoneAlert.confirmDialog(message: "Selecting this seed will switch network management to manual mode.", cancelTitle: "Cancel", confirmTitle: "Confirm", didCancel: {}) {
                UserDefaultsManager.seed = self.tableNodes[indexPath.row].URL
                UserDefaultsManager.useDefaultSeed = false
                DispatchQueue.main.async { tableView.reloadData() }
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 67.5
        }
    }
}
