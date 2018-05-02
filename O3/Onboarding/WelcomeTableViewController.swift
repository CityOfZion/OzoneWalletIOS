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
    @IBOutlet weak var pleaseBackupWarning: UILabel!
    @IBOutlet weak var privateKeyTitle: UILabel!
    @IBOutlet weak var startButton: ShadowedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))
        self.privateKeyQR.image = UIImage(qrData: Authenticated.account?.wif ?? "", width: self.privateKeyQR.frame.width, height: self.privateKeyQR.frame.height)
        self.privateKeyLabel.text = Authenticated.account?.wif ?? ""

        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .authenticationPrompt("")
                    .set((Authenticated.account?.wif)!, key: "ozonePrivateKey")
            } catch _ {
                DispatchQueue.main.async {
                    OzoneAlert.alertDialog(message: OnboardingStrings.keychainFailureError, dismissTitle: OzoneAlert.okPositiveConfirmString) {
                        Authenticated.account = nil
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func startTapped(_ sender: Any) {
        OzoneAlert.confirmDialog(message: OnboardingStrings.haveSavedPrivateKeyConfirmation, cancelTitle: OzoneAlert.notYetNegativeConfirmString, confirmTitle: OzoneAlert.confirmPositiveConfirmString, didCancel: {}) {
            DispatchQueue.main.async {
                HUD.show(.labeledProgress(title: nil, subtitle: OnboardingStrings.selectingBestNodeTitle))
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

    func setLocalizedStrings() {
        pleaseBackupWarning.text = OnboardingStrings.pleaseBackupWarning
        privateKeyTitle.text = OnboardingStrings.privateKeyTitle
        self.title = OnboardingStrings.welcomeTitle
        startButton.setTitle(OnboardingStrings.startActionTitle, for: UIControlState())
    }
}
