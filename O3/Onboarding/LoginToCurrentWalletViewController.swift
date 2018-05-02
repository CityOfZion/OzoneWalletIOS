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
    @IBOutlet weak var cancelButton: UIButton!

    func login() {
        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                let key = try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .authenticationPrompt(OnboardingStrings.authenticationPrompt)
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
                            DispatchQueue.main.async {
                                SwiftTheme.ThemeManager.setTheme(index: UserDefaultsManager.themeIndex)
                                self.performSegue(withIdentifier: "loggedin", sender: nil) }
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
        setLocalizedStrings()
        login()
    }

    @IBAction func didTapLogin(_ sender: Any) {
        login()
    }

    @IBAction func didTapCancel(_ sender: Any) {
        SwiftTheme.ThemeManager.setTheme(index: 2)
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
    }

    func setLocalizedStrings() {
        cancelButton.setTitle(OzoneAlert.cancelNegativeConfirmString, for: UIControlState())
        if #available(iOS 8.0, *) {
            var error: NSError?
            let hasTouchID = LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
            //if touchID is unavailable.
            //change the caption of the button here.
            if hasTouchID == false {
                loginButton?.setTitle(OnboardingStrings.loginWithExistingPasscode, for: .normal)
            } else {
                loginButton?.setTitle(OnboardingStrings.loginWithExistingBiometric, for: .normal)
            }
        }
    }
}
