//
//  PreCreateWalletViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
import NeoSwift

class PreCreateWalletViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var createNewWalletButton: ShadowedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWelcome" {
            Authenticated.account = Account()
        }
    }

    func setLocalizedStrings() {
        self.title = OnboardingStrings.createNewWalletTitle
    createNewWalletButton.setTitle(OnboardingStrings.createNewWalletTitle, for: UIControlState())
        titleLabel.text = OnboardingStrings.alreadyHaveWalletWarning

    }
}
