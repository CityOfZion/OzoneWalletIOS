//
//  NetworkTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 10/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class NetworkTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Network"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2 //seeds.count
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
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "networkSeedCell")!
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
