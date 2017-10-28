//
//  PreCreateWalletViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class PreCreateWalletViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create a Wallet"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setNeedsStatusBarAppearanceUpdate()

        //if user already have an o3 wallet address we then show that creating wallet will overwrite the existing wallet
        if UserDefaultsManager.o3WalletAddress != nil {

        }

    }

}
