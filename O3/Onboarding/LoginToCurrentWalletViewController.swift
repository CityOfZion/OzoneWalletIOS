//
//  LoginToCurrentWalletViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
import KeychainAccess
import NeoSwift
import LocalAuthentication
import SwiftTheme

class LoginToCurrentWalletViewController: UIViewController {

    @IBOutlet var loginButton: UIButton?
    @IBOutlet var mainImageView: UIImageView?

    func login() {
        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                let key = try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .authenticationPrompt("Log in to your existing wallet stored on this device")
                    .get("ozonePrivateKey")
                if key == nil {
                    return
                }

                guard let account = Account(wif: key!) else {
                    return
                }
                O3HUD.start()
                Authenticated.account = account
                DispatchQueue.global(qos: .background).async {
                    let bestNode = NEONetworkMonitor.autoSelectBestNode()
                    DispatchQueue.main.async {
                        if bestNode != nil {
                            UserDefaultsManager.seed = bestNode!
                            UserDefaultsManager.useDefaultSeed = false
                        }
                        O3HUD.stop {
                            SwiftTheme.ThemeManager.setTheme(index: UserDefaultsManager.themeIndex)
                            DispatchQueue.main.async { self.performSegue(withIdentifier: "loggedin", sender: nil) }
                        }
                    }
                }
            } catch _ {

            }
        }
    }
    override func viewDidLoad() {
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.viewDidLoad()
        if #available(iOS 8.0, *) {
            var error: NSError?
            let hasTouchID = LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
            //if touchID is unavailable.
            //change the caption of the button here.
            if hasTouchID == false {
                loginButton?.setTitle("Log in using passcode", for: .normal)
            }
        }
        login()
    }

    @IBAction func didTapLogin(_ sender: Any) {
        login()
    }

    @IBAction func didTapCancel(_ sender: Any) {
        SwiftTheme.ThemeManager.setTheme(index: 2)
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
    }
}
