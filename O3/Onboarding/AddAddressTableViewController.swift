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
    @IBOutlet var proceedButton: ShadowedButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x:0, y:0, width:self.tableView.frame.size.width, height: 1))
        addressTextField.delegate = self
        self.checkToProceed()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        //perhaps add HUD
        let address = addressTextField.text.trim()
        address.validNEOAddress { (valid) in
            if valid == false {
                //localize string later
                OzoneAlert.alertDialog(message: "Invalid Address", dismissTitle: "OK", didDismiss: {
                    self.addressTextField.becomeFirstResponder()
                })
                return
            }
            DispatchQueue.main.async {
                Authenticated.watchOnlyAddresses?.append(address)
                self.performSegue(withIdentifier: "segueToMainFromAddAddress", sender: nil)
            }
        }
    }

    @IBAction func checkToProceed() {
        proceedButton.isEnabled = addressTextField.text.isEmpty == false
    }
}

extension AddAddressTableViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        self.checkToProceed()
    }
}
