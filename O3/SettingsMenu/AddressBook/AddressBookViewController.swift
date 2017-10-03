//
//  AddressBookViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class AddressBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddressAddDelegate, AddAddressCellDelegate, HalfModalPresentable {
    @IBOutlet weak var tableView: UITableView!
    var contacts = [Contact]()

    func loadContacts() {
        do {
            contacts = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(Contact.fetchRequest())
        } catch {
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "angle-up"), style: .plain, target: self, action: #selector(maximize(_:)))

        navigationItem.rightBarButtonItem = rightBarButton
        tableView.delegate = self
        tableView.dataSource = self
        loadContacts()
        tableView.reloadData()
    }

    @objc func maximize(_ sender: Any) {
        maximizeToFullScreen()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contacts.count == 0 && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addContactTableViewCell") as? AddContactTableViewCell else {
                fatalError("Undefined table view behavior")
            }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        } else if indexPath.row < contacts.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressBookEntryTableViewCell") as? AddressBookEntryTableViewCell else {
                fatalError("Undefined table view behavior")
            }
            cell.data = AddressBookEntryTableViewCell.Data(addressName: contacts[indexPath.row].nickName ?? "",
                                                               address: contacts[indexPath.row].address ?? "")
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addContactTableViewCell") as? AddContactTableViewCell else {
            fatalError("Undefined table view behavior")
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }

    func addressAdded(_ address: String, nickName: String) {
        let context = UIApplication.appDelegate.persistentContainer.viewContext
        let contact = Contact(context: context)
        contact.address = address
        contact.nickName = nickName
        UIApplication.appDelegate.saveContext()
        self.loadContacts()
        tableView.reloadData()
    }

    func tappedRemoveAddress(_ index: Int) {
        OzoneAlert.confirmDialog(message: "Are you sure you want to delete", cancelTitle: "Cancel", confirmTitle: "OK", didCancel: {}) {
            UIApplication.appDelegate.persistentContainer.viewContext.delete(self.contacts[index])
            try? UIApplication.appDelegate.persistentContainer.viewContext.save()
            self.loadContacts()
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? AddressEntryTableViewController                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               else {
            fatalError("Undefined segue performed")
        }
        dest.delegate = self
    }

    func segueToAdd() {
        performSegue(withIdentifier: "showAddContact", sender: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < contacts.count {
            tappedRemoveAddress(indexPath.row)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count + 1
    }
}
