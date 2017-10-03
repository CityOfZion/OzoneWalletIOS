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
    let keychain = Keychain(service: "network.o3.wallet")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x:0, y: 0, width:self.tableView.frame.size.width, height: 1))
        self.privateKeyQR.image = UIImage(qrData: Authenticated.account?.wif ?? "", width: self.privateKeyQR.frame.width, height: self.privateKeyQR.frame.height)
        self.privateKeyLabel.text = Authenticated.account?.wif ?? ""

        DispatchQueue.global().async {
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set((Authenticated.account?.wif)!, key: "ozonePrivateKey")
            } catch let error {
                fatalError("Unable to store private key in keychain \(error.localizedDescription)")
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func startTapped(_ sender: Any) {
        DispatchQueue.main.async {

        }
        DispatchQueue.global().async {
            do {
                let password = try self.keychain
                    .authenticationPrompt("Authenticate to view your private key")
                    .get("ozonePrivateKey")

            } catch let error {
                fatalError("Unable to store private key in keychain \(error.localizedDescription)")
            }
        }
    }
}

        //DispatchQueue.global().async {
        //    print (keychain["ozonePrivateKey"])
            //self.performSegue(withIdentifier: "segueToMainFromWelcome", sender: nil)
        //}
 //   }
