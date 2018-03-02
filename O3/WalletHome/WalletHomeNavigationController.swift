//
//  WalletHomeNavigationController.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/23/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
import SwiftTheme

class WalletHomeNavigationController: UINavigationController {
    override func viewDidLoad() {
        DispatchQueue.main.async {
            UIApplication.shared.theme_setStatusBarStyle(ThemeStatusBarStylePicker(styles: Theme.light.statusBarStyle, Theme.dark.statusBarStyle), animated: true)
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationController?.hideHairline()
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }
        super.viewDidLoad()
    }
}
