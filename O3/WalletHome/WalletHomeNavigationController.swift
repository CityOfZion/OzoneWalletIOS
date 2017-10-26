//
//  WalletHomeNavigationController.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/23/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class WalletHomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = UserDefaultsManager.theme.statusBarStyle
        setNeedsStatusBarAppearanceUpdate()
        self.hideHairline()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationBar.barTintColor = UserDefaultsManager.theme.backgroundColor

        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = UserDefaultsManager.theme.backgroundColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                                        NSAttributedStringKey.font: ThemeManager.largeTitleFont]
    }
}
