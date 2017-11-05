//
//  AddressBookViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class AddressBookViewController: ThemedViewController, UITableViewDelegate, UITableViewDataSource, AddressAddDelegate, AddAddressCellDelegate, HalfModalPresentable {
    @IBOutlet weak var tableView: UITableView!
    var contacts = [Contact]()

    func loadContacts() {
        do {
            contacts = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(Contact.fetchRequest())
        } catch {
            return
        }
    }

    func setThemedElements() {
        themedTableViews = [self.tableView]
    }

    override func viewDidLoad() {
        setThemedElements()
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
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit Name", style: .default) { _ in
            self.tappedEditWatchOnlyAddress(indexPath.row)
        }
        actionSheet.addAction(edit)

        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.tappedRemoveAddress(indexPath.row)
        }
        actionSheet.addAction(delete)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }

    func tappedEditWatchOnlyAddress(_ index: Int) {
        let toUpdate = self.contacts[index]
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count + 1
    }
}
