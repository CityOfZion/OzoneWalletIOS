//
//  WatchOnlyAddressViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class WatchOnlyAddressViewController: ThemedViewController, UITableViewDelegate, UITableViewDataSource, AddressAddDelegate, AddAddressCellDelegate, HalfModalPresentable {
    @IBOutlet weak var tableView: UITableView!
    var watchAddresses = [WatchAddress]()

    func loadWatchAddresses() {
        do {
            watchAddresses = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(WatchAddress.fetchRequest())
        } catch {
            return
        }
    }

    func setThemedElements() {
        themedTableViews = [tableView]
    }

    override func viewDidLoad() {
        setThemedElements()
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "angle-up"), style: .plain, target: self, action: #selector(maximize(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        tableView.delegate = self
        tableView.dataSource = self
        loadWatchAddresses()
        tableView.reloadData()
    }

    @objc func maximize(_ sender: Any) {
        maximizeToFullScreen()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if watchAddresses.count == 0 && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addAddressTableViewCell") as? AddAddressTableViewCell else {
                fatalError("Undefined table view behavior")
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row < watchAddresses.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "watchOnlyAddressTableViewCell") as? WatchOnlyAddressTableViewCell else {
                fatalError("Undefined table view behavior")
            }
            cell.data = WatchOnlyAddressTableViewCell.Data(addressName: watchAddresses[indexPath.row].nickName ?? "",
                                                           address: watchAddresses[indexPath.row].address ?? "")
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addAddressTableViewCell") as? AddAddressTableViewCell else {
            fatalError("Undefined table view behavior")
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }

    func addressAdded(_ address: String, nickName: String) {
        let context = UIApplication.appDelegate.persistentContainer.viewContext
        let watchAddress = WatchAddress(context: context)
        watchAddress.address = address
        watchAddress.nickName = nickName
        UIApplication.appDelegate.saveContext()
        self.loadWatchAddresses()
        NotificationCenter.default.post(name: Notification.Name("UpdatedWatchOnlyAddress"), object: nil)
        tableView.reloadData()
    }

    func segueToAdd() {
        performSegue(withIdentifier: "showAddWatchOnlyAddress", sender: nil)
    }

    func tappedRemoveAddress(_ index: Int) {
        OzoneAlert.confirmDialog(message: "Are you sure you want to delete", cancelTitle: "Cancel", confirmTitle: "OK", didCancel: {}) {
            UIApplication.appDelegate.persistentContainer.viewContext.delete(self.watchAddresses[index])
            try? UIApplication.appDelegate.persistentContainer.viewContext.save()
            self.loadWatchAddresses()
            NotificationCenter.default.post(name: Notification.Name("UpdatedWatchOnlyAddress"), object: nil)
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < watchAddresses.count {
            tappedRemoveAddress(indexPath.row)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchAddresses.count + 1
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? AddressEntryTableViewController else {
            fatalError("Unknow segue destination")
        }
        dest.delegate = self
    }
}
