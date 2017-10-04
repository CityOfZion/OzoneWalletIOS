//
//  SettingsMenuTableViewControllwe.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import KeychainAccess
import UIKit

class SettingsMenuTableViewController: UITableViewController, HalfModalPresentable {
    @IBOutlet weak var showPrivateKeyView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var networkCell: UITableViewCell!

    var netString = Neo.isTestnet ? "Network: Test Network": "Network: Main Network" {
        didSet {
            self.setNetLabel()
        }
    }

    func setNetLabel() {
        guard let label = networkCell.viewWithTag(1) as? UILabel else {
            fatalError("Undefined behavior with table view")
        }
        DispatchQueue.main.async { label.text = self.netString }
    }

    override func viewDidLoad() {
        navigationController?.hideHairline()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: Theme.Light.textColor, NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 32) as Any]
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "angle-up"), style: .plain, target: self, action: #selector(SettingsMenuTableViewController.maximize(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        showPrivateKeyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPrivateKey)))
        contactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMail)))
        shareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(share)))
        networkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeNetwork)))
        setNetLabel()
    }

    @objc func maximize(_ sender: Any) {
        maximizeToFullScreen()
    }

    @objc func changeNetwork() {
       let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let testNetAction = UIAlertAction(title: "Test Network", style: .default) { _ in
            Neo.isTestnet = true
            self.netString = "Network: Test Network"
        }

        let mainNetAction = UIAlertAction(title: "Main Network", style: .default) { _ in
            Neo.isTestnet = false
            self.netString = "Network: Main Network"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }

        optionMenu.addAction(testNetAction)
        optionMenu.addAction(mainNetAction)
        optionMenu.addAction(cancelAction)

        present(optionMenu, animated: true, completion: nil)

    }

    @objc func sendMail() {
        let email = "O3WalletApp@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }

    @objc func share() {
        let shareURL = URL(string: "https://o3.network/")
        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func showPrivateKey() {
        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                let password = try keychain
                    .authenticationPrompt("Authenticate to view your private key")
                    .get("ozonePrivateKey")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueToPrivateKey", sender: nil)
                }

            } catch let error {

            }
        }
    }
}
