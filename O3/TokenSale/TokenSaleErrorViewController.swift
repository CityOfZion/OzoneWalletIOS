//
//  TokenSaleErrorViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/16/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

class TokenSaleErrorViewController: UIViewController {
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    func setThemedElements() {
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        setThemedElements()
    }

    @IBAction func contactTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            let email = "support@o3.network"
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        }
    }

    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func setLocalizedStrings() {
        errorDescriptionLabel.text = TokenSaleStrings.transactionErrorDescriptionTitle
        closeButton.setTitle(TokenSaleStrings.closeTitle, for: UIControlState())
        contactButton.setTitle(TokenSaleStrings.contact, for: UIControlState())
    }
}
