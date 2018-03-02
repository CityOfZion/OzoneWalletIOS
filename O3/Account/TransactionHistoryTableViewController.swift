//
//  TransactionHistoryTableViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import NeoSwift

class TransactionHistoryTableViewController: UITableViewController {

    var transactionHistory = [TransactionHistoryEntry]()
    func loadTransactionHistory() {
        Neo.client.getTransactionHistory(for: Authenticated.account?.address ?? "") { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
                return
            case .success(let txHistory):
                self.transactionHistory = txHistory.entries
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        self.loadTransactionHistory()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)

    }

    @objc func reloadData() {
        self.loadTransactionHistory()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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
        cell.selectionStyle = .none
        cell.data = transactionCellData
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransactionID  = transactionHistory[indexPath.row].transactionID
        self.performSegue(withIdentifier: "segueToWebview", sender: selectedTransactionID)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return transactionHistory.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWebview" {
            guard let dest = segue.destination as? TransactionWebViewController else {
                fatalError("Undefined Segue behavior")
            }
            if  let selectedTransactionID = sender as? String {
                dest.transactionID = selectedTransactionID
            }
        }
    }
}
