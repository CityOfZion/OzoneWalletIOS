//
//  LoginTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift
import Channel
import KeychainAccess
import PKHUD

class LoginTableViewController: UITableViewController, QRScanDelegate {
    @IBOutlet weak var wifTextField: UITextView!
    @IBOutlet weak var loginButton: ShadowedButton!
    var watchAddresses = [WatchAddress]()

    func loadWatchAddresses() {
        do {
            watchAddresses = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(WatchAddress.fetchRequest())
            for a in watchAddresses {
                Channel.shared().subscribe(toTopic: a.address!)
            }
        } catch {
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x:0, y:0, width:self.tableView.frame.size.width, height: 1))
        setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cameraAlt"), style: .plain, target: self, action: #selector(qrScanTapped(_:)))
        self.wifTextField.delegate = self
        // let keychain = Keychain(service: "network.o3.neo.wallet")
        //        DispatchQueue.global().async {
        //            do {
        //                let key = try keychain
        //                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
        //                    .authenticationPrompt("Log in to your existing wallet stored on this device")
        //                    .get("ozonePrivateKey")
        //                if key == nil {
        //                    return
        //                }
        //                guard let account = Account(wif: key!) else {
        //                    return
        //                }
        //               //O3HUD.start()
        //                Authenticated.account = account
        //                account.network = UserDefaultsManager.network
        //                O3HUD.stop {
        //                    DispatchQueue.main.async { self.performSegue(withIdentifier: "segueToMainFromLogin", sender: nil) }
        //                }
        //            } catch _ {
       self.checkToProceed()
        //            }
        //        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let account = Account(wif: self.wifTextField.text ?? "") else {
            return
        }
        let keychain = Keychain(service: "network.o3.neo.wallet")

        Authenticated.account = account

        //subscribe to a topic which is an address to receive push notification
        //enable push notifcation. maybe put this in somewhere else?
        Channel.pushNotificationEnabled(true)

        HUD.show(.labeledProgress(title: nil, subtitle: "Selecting best node..."))
        DispatchQueue.global(qos: .background).async {
            let bestNode = NEONetworkMonitor.autoSelectBestNode()
            DispatchQueue.main.async {
                HUD.hide()
                if bestNode != nil {
                    UserDefaultsManager.seed = bestNode!
                    UserDefaultsManager.useDefaultSeed = false
                }
                do {
                    //save pirivate key to keychain
                    try keychain
                        .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                        .set(account.wif, key: "ozonePrivateKey")
                    DispatchQueue.main.async { self.performSegue(withIdentifier: "segueToMainFromLogin", sender: nil) }
                } catch _ {
                    return
                }
            }
        }
    }

    @objc func qrScanTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToQrFromLogin", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToQrFromLogin" {
            guard let dest = segue.destination as? QRScannerController else {
                fatalError("Undefined segue behavior")
            }
            dest.delegate = self
        } else {
            loadWatchAddresses()
            Authenticated.watchOnlyAddresses = watchAddresses.map {$0.address ?? ""}
        }
    }

    func qrScanned(data: String) {
        DispatchQueue.main.async { self.wifTextField.text = data }
    }

    @IBAction func checkToProceed() {
        DispatchQueue.main.async { self.loginButton.isEnabled = self.wifTextField.text.isEmpty == false }
    }
}

extension LoginTableViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        self.checkToProceed()
    }
}
