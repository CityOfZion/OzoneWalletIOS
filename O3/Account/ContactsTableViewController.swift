//
//  ContactsTableViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import CoreData
import DeckTransition
import Crashlytics

class ContactsTableViewController: UITableViewController, AddressAddDelegate {
    @IBOutlet weak var addAddressButton: ShadowedButton!
    @IBOutlet weak var addAddressDescriptionLabel: UILabel!
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var fetchedResultsController: NSFetchedResultsController<Contact>?
    var selectedAddress = ""

    @objc func loadData() {
        self.tableView.refreshControl?.beginRefreshing()
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nickName", ascending: true)]

        let context = appDelegate?.persistentContainer.viewContext

        fetchedResultsController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        loadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AddressEntryTableViewController {
            dest.delegate = self
        } else if let dest = segue.destination as? SendTableViewController {
            dest.preselectedAddress = selectedAddress
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressBookEntryTableViewCell") as? AddressBookEntryTableViewCell else {
            fatalError("Undefined table view behavior")
        }

        self.configureCell(cell: cell, indexPath: indexPath)
        return cell

    }

    func addressAdded(_ address: String, nickName: String) {
        let context = UIApplication.appDelegate.persistentContainer.viewContext
        let contact = Contact(context: context)
        contact.address = address
        contact.nickName = nickName
        UIApplication.appDelegate.saveContext()
    }

    @IBAction func tappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func sendTapped() {
        guard let modal = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendTableViewController") as? SendTableViewController else {
            fatalError("Unsupported Segue")
        }
        modal.preselectedAddress = selectedAddress
        let nav = WalletHomeNavigationController(rootViewController: modal)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .automatic
        modal.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "times"), style: .plain, target: self, action: #selector(tappedLeftBarButtonItem(_:)))
        let transitionDelegate = DeckTransitioningDelegate()
        nav.transitioningDelegate = transitionDelegate
        nav.modalPresentationStyle = .custom
        present(nav, animated: true, completion: nil)
    }

    func tappedRemoveAddress(_ index: Int) {
        OzoneAlert.confirmDialog(message: AccountStrings.areYouSureDelete, cancelTitle: OzoneAlert.cancelNegativeConfirmString, confirmTitle: OzoneAlert.okPositiveConfirmString, didCancel: {

        }) {
            guard let contacts = self.fetchedResultsController?.fetchedObjects else { return  }
            UIApplication.appDelegate.persistentContainer.viewContext.delete(contacts[index])
            try? UIApplication.appDelegate.persistentContainer.viewContext.save()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: AccountStrings.editName, style: .default) { _ in
            self.tappedEditWatchOnlyAddress(indexPath.row)
        }
        actionSheet.addAction(edit)

        let send = UIAlertAction(title: AccountStrings.sendToAddress, style: .default) { _ in
            self.selectedAddress = self.fetchedResultsController?.object(at: indexPath).address ?? ""
            self.sendTapped()
        }
        actionSheet.addAction(send)

        let copy = UIAlertAction(title: AccountStrings.copyAddress, style: .default) { _ in
            UIPasteboard.general.string = self.fetchedResultsController?.object(at: indexPath).address ?? ""
        }
        actionSheet.addAction(copy)

        let delete = UIAlertAction(title: AccountStrings.delete, style: .destructive) { _ in
            self.tappedRemoveAddress(indexPath.row)
        }
        actionSheet.addAction(delete)

        let cancel = UIAlertAction(title: OzoneAlert.cancelNegativeConfirmString, style: .cancel) { _ in

        }
        actionSheet.addAction(cancel)
        let cell = tableView.cellForRow(at: indexPath)
        actionSheet.popoverPresentationController?.sourceView = cell
        present(actionSheet, animated: true, completion: nil)
    }

    func tappedEditWatchOnlyAddress(_ index: Int) {
        guard let contacts = fetchedResultsController?.fetchedObjects else { return  }
        let toUpdate = contacts[index]
        let alert = UIAlertController(title: AccountStrings.editName, message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.text = toUpdate.nickName
        }
        let save = UIAlertAction(title: AccountStrings.save, style: .default) { _ in
            let textfield = alert.textFields?.first
            toUpdate.nickName = textfield?.text?.trim()
            try? UIApplication.appDelegate.persistentContainer.viewContext.save()
            Answers.logCustomEvent(withName: "Contact Added",
                                   customAttributes: ["Total Contacts": contacts.count + 1])
            self.tableView.reloadData()
        }
        alert.addAction(save)
        let cancel = UIAlertAction(title: OzoneAlert.cancelNegativeConfirmString, style: .cancel) { _ in

        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contacts = fetchedResultsController?.fetchedObjects else { return 0 }
        return contacts.count
    }

    func configureCell(cell: AddressBookEntryTableViewCell, indexPath: IndexPath) {
        if let contact = fetchedResultsController?.object(at: indexPath) {
            cell.data = AddressBookEntryTableViewCell.Data(addressName: contact.nickName ?? "",
                                                           address: contact.address ?? "")
            cell.selectionStyle = .none
        }
    }

}

extension ContactsTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }

    func setLocalizedStrings() {
        addAddressButton.setTitle(AccountStrings.addContact, for: UIControlState())
        addAddressDescriptionLabel.text = AccountStrings.addContactDescription

    }
}
