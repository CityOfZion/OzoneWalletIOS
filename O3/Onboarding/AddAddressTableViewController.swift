//
//  AddAddressTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class AddAddressTableViewController: UITableViewController {
    @IBOutlet weak var addressTextField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x:0, y:0, width:self.tableView.frame.size.width, height: 1))
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        //TODO: Need some error checking here
        Authenticated.watchOnlyAddresses?.append(addressTextField.text ?? "")
        self.performSegue(withIdentifier: "segueToMainFromAddAddress", sender: nil)
    }

}
