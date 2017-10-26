//
//  PrivateKeyViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class PrivateKeyViewController: UIViewController {
    @IBOutlet weak var qrView: UIImageView!
    @IBOutlet weak var privateKeyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UserDefaultsManager.theme.backgroundColor
        privateKeyLabel.text = Authenticated.account?.wif
        qrView.image = UIImage(qrData: Authenticated.account?.wif ?? "", width: qrView.frame.width, height: qrView.frame.height)
    }
}
