//
//  WatchOnlyAddressViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import Channel

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
        Channel.shared().subscribe(toTopic: watchAddress.address!)
        NotificationCenter.default.post(name: Notification.Name("UpdatedWatchOnlyAddress"), object: nil)
        tableView.reloadData()
    }

    func segueToAdd() {
        performSegue(withIdentifier: "showAddWatchOnlyAddress", sender: nil)
    }

    func tappedRemoveAddress(_ index: Int) {
        OzoneAlert.confirmDialog(message: "Are you sure you want to delete", cancelTitle: "Cancel", confirmTitle: "Delete", didCancel: {}) {
            let toDelete = self.watchAddresses[index]
            Channel.shared().unsubscribe(fromTopic: toDelete.address!) {}
            UIApplication.appDelegate.persistentContainer.viewContext.delete(self.watchAddresses[index])
            try? UIApplication.appDelegate.persistentContainer.viewContext.save()
            self.loadWatchAddresses()
            NotificationCenter.default.post(name: Notification.Name("UpdatedWatchOnlyAddress"), object: nil)
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit Name", style: .default) { _ in
            self.tappedEditWatchOnlyAddress(indexPath.row)
        }
        actionSheet.addAction(edit)

        let copy = UIAlertAction(title: "Copy", style: .default) { _ in
             UIPasteboard.general.string = self.watchAddresses[indexPath.row].address ?? ""
        }
        actionSheet.addAction(copy)

        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.tappedRemoveAddress(indexPath.row)
        }
        actionSheet.addAction(delete)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }
        actionSheet.addAction(cancel)
        let cell = tableView.cellForRow(at: indexPath)
        actionSheet.popoverPresentationController?.sourceView = cell
        present(actionSheet, animated: true, completion: nil)
    }

    func tappedEditWatchOnlyAddress(_ index: Int) {
     let toUpdate = self.watchAddresses[index]
        let alert = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.text = toUpdate.nickName
        }
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            let textfield = alert.textFields?.first
            toUpdate.nickName = textfield?.text?.trim()
            try? UIApplication.appDelegate.persistentContainer.viewContext.save()
            self.tableView.reloadData()
        }
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
