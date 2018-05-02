//
//  FirstTimeLoginViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class FirstTimeLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = OnboardingStrings.loginTitle
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.hideHairline()
        setNeedsStatusBarAppearanceUpdate()
    }

}
