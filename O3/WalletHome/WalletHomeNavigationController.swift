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
        UIApplication.shared.statusBarStyle = .default
        setNeedsStatusBarAppearanceUpdate()
        self.hideHairline()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: Theme.Light.textColor,
                                                                        NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 32) as Any]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
