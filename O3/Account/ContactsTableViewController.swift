//
//  ContactsTableViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import CoreData
class ContactsTableViewController: ThemedTableViewController, AddressAddDelegate {

    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var fetchedResultsController: NSFetchedResultsController<Contact>?

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

        loadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? AddressEntryTableViewController                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               else {
            fatalError("Undefined segue performed")
        }
        dest.delegate = self
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

    func tappedRemoveAddress(_ index: Int) {
        OzoneAlert.confirmDialog(message: "Are you sure you want to delete", cancelTitle: "Cancel", confirmTitle: "OK", didCancel: {

        }) {
            guard let contacts = self.fetchedResultsController?.fetchedObjects else { return  }
            UIApplication.appDelegate.persistentContainer.viewContext.delete(contacts[index])
            try? UIApplication.appDelegate.persistentContainer.viewContext.save()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        guard let contacts = fetchedResultsController?.fetchedObjects else { return  }
        let toUpdate = contacts[index]
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contacts = fetchedResultsController?.fetchedObjects else { return 0 }
        return contacts.count
    }

    func configureCell(cell: AddressBookEntryTableViewCell, indexPath: IndexPath) {
        if let contact = fetchedResultsController?.object(at: indexPath) {
            cell.data = AddressBookEntryTableViewCell.Data(addressName:contact.nickName ?? "",
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
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            //            if let indexPath = indexPath, let cell = iTableView.cellForRow(at: indexPath) {
            //                configureCell(cell, at: indexPath)
            //            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        }
    }
}
