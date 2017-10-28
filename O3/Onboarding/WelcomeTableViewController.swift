//
//  WelcomeTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class WelcomeTableViewController: UITableViewController {
    @IBOutlet weak var privateKeyQR: UIImageView!
    @IBOutlet weak var privateKeyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x:0, y: 0, width:self.tableView.frame.size.width, height: 1))
        self.privateKeyQR.image = UIImage(qrData: Authenticated.account?.wif ?? "", width: self.privateKeyQR.frame.width, height: self.privateKeyQR.frame.height)
        self.privateKeyLabel.text = Authenticated.account?.wif ?? ""

        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                if UserDefaultsManager.o3WalletAddress != nil {
                    try keychain
                        .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                        .authenticationPrompt("Authenticated will overwrite the private key currently stored in your keychain")
                        .set((Authenticated.account?.wif)!, key: "ozonePrivateKey")
                } else {
                    try keychain.set((Authenticated.account?.wif)!, key: "ozonePrivateKey")
                }

            } catch let error {
                DispatchQueue.main.async { self.navigationController?.popViewController(animated: true) }
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func startTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToMainFromWelcome", sender: nil)
    }
}
