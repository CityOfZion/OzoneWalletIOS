//
//  TransactionHistoryTableViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import NeoSwift

class TransactionHistoryTableViewController: UITableViewController, TransactionHistoryDelegate {

    var transactionHistory = [NeoScanTransactionEntry]()
    var supportedTokens = [NEP5Token]()

    //paging (neoscan starts at page 1)
    var isDataLoading = false
    var pageNo = 1
    var limit = 15
    var offset = 0 // (pageNO * limit) - 15
    var endReached = false

    var contacts = [Contact]()
    var watchAddresses = [WatchAddress]()

    func loadContacts() {
        do {
            contacts = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(Contact.fetchRequest())
        } catch {
            return
        }
    }

    func loadWatchAddresses() {
        do {
            watchAddresses = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(WatchAddress.fetchRequest())
        } catch {
            return
        }
    }

    func initialLoad() {
        O3Client().getTokens { result in
            switch result {
            case .failure:
                return
            case .success(let tokens):
                self.supportedTokens = tokens
                self.loadTransactionHistory(appendPage: false, pageNo: 1)
            }
        }
    }

    func loadTransactionHistory(appendPage: Bool, pageNo: Int) {
        NeoScan().getTransactionHistory(address: Authenticated.account?.address ?? "", page: pageNo) { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
                return
            case .success(let txHistory):
                if txHistory.total_pages == pageNo {
                    self.endReached = true
                }

                if appendPage {
                    self.transactionHistory += txHistory.entries
                } else {
                    self.transactionHistory = txHistory.entries
                }
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWatchAddresses()
        loadContacts()
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        self.initialLoad()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }

    @objc func reloadData() {
        isDataLoading = false
        pageNo = 1
        limit = 15
        offset = 0
        endReached = false
        self.loadTransactionHistory(appendPage: false, pageNo: 1)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let transactionEntry = transactionHistory[indexPath.row]
        var transactionData: TransactionCell.TransactionData?
        var assetName = "Token"
        var assetDecimals = 8
        var divisor = 1.0
        if let i = supportedTokens.index(where: {transactionEntry.asset.contains($0.tokenHash)}) {
            assetName = supportedTokens[i].symbol.uppercased()
            assetDecimals = supportedTokens[i].decimal
            divisor = 100000000.0
        } else if NeoSwift.AssetId.gasAssetId.rawValue.contains(transactionEntry.asset) {
            assetName = "GAS"
            assetDecimals = 8
        } else if NeoSwift.AssetId.neoAssetId.rawValue.contains(transactionEntry.asset) {
            assetName = "NEO"
            assetDecimals = 0
        }

        transactionData = TransactionCell.TransactionData(type: TransactionCell.TransactionType.send,
                                                        date: UInt64(transactionEntry.block_height),
                                                        asset: assetName, toAddress: transactionEntry.address_to,
                                                        fromAddress: transactionEntry.address_from,
                                                        amount: (transactionEntry.amount / divisor), precision: assetDecimals)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell else {
            fatalError("Undefined table view behavior")
        }
        cell.selectionStyle = .none
        cell.delegate = self
        cell.data = transactionData

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransactionID  = transactionHistory[indexPath.row].txid
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

    func getContacts() -> [Contact] {
        return contacts
    }

    func getWatchAddresses() -> [WatchAddress] {
        return watchAddresses
    }

    //Pagination
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }

    //Pagination
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            if !isDataLoading && !endReached {
                isDataLoading = true
                self.pageNo += 1
                self.limit += 15
                self.offset = (self.limit * self.pageNo) - 15
                loadTransactionHistory(appendPage: true, pageNo: pageNo)
            }
        }
    }
}
