//
//  AddressSelectTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

protocol AddressSelectDelegate: class {
    func selectedAddress(_ address: String)
}

class AddressSelectTableViewController: UITableViewController, HalfModalPresentable {
    weak var delegate: AddressSelectDelegate?
    var contacts = [Contact]()

    func loadContacts() {
        do {
            contacts = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(Contact.fetchRequest())
        } catch {
            return
        }
    }

    func addTheme() {
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        applyNavBarTheme()
    }

    override func viewDidLoad() {
        addTheme()
        super.viewDidLoad()
        loadContacts()
        self.title = SendStrings.addressBook
        tableView.reloadData()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressSelectionCell") as? AddressSelectionCell else {
            fatalError("Undefined tableview behavior")
        }
        cell.nicknameLabel.text = contact.nickName ?? ""
        cell.addressLabel.text = contact.address ?? ""
        return cell

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedAddress(contacts[indexPath.row].address ?? "")
        self.dismiss(animated: true)
    }
}
