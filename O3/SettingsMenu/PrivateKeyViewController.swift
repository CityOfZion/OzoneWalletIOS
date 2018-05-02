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
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        privateKeyLabel.text = Authenticated.account?.wif
        qrView.image = UIImage(qrData: Authenticated.account?.wif ?? "", width: qrView.frame.width, height: qrView.frame.height)
        title = SettingsStrings.privateKeyTitle
    }

    @IBAction func shareTapped(_ sender: Any) {
        let string = privateKeyLabel.text!
        let activityViewController = UIActivityViewController(activityItems: [string], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
