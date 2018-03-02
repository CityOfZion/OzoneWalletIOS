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
import PKHUD
import NeoSwift
import SwiftTheme

class WelcomeTableViewController: UITableViewController {
    @IBOutlet weak var privateKeyQR: UIImageView!
    @IBOutlet weak var privateKeyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))
        self.privateKeyQR.image = UIImage(qrData: Authenticated.account?.wif ?? "", width: self.privateKeyQR.frame.width, height: self.privateKeyQR.frame.height)
        self.privateKeyLabel.text = Authenticated.account?.wif ?? ""

        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .authenticationPrompt("You already have an account on the device. Registering a new one will delete all private key information from your device. Authenticate to delete and generate a new account.")
                    .set((Authenticated.account?.wif)!, key: "ozonePrivateKey")
            } catch _ {
                DispatchQueue.main.async { self.navigationController?.popViewController(animated: true) }
            }
        }
    }

    deinit {
        print ("hello")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func startTapped(_ sender: Any) {
        OzoneAlert.confirmDialog(message: "I confirm that I have read the warning text and have backed up my private key in another secure location.", cancelTitle: "Not yet.", confirmTitle: "Confirm", didCancel: {}) {
            DispatchQueue.main.async {
                HUD.show(.labeledProgress(title: nil, subtitle: "Selecting best node..."))
                DispatchQueue.global(qos: .background).async {
                    let bestNode = NEONetworkMonitor.autoSelectBestNode()
                    DispatchQueue.main.async {
                        HUD.hide()
                        if bestNode != nil {
                            UserDefaultsManager.seed = bestNode!
                            UserDefaultsManager.useDefaultSeed = false
                        }
                        ThemeManager.setTheme(index: UserDefaultsManager.themeIndex)
                        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    }
                }
            }
        }
    }
}
