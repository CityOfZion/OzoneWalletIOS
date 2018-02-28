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
import SwiftTheme

class SettingsMenuTableViewController: UITableViewController, HalfModalPresentable {
    @IBOutlet weak var showPrivateKeyView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var networkCell: UITableViewCell!
    @IBOutlet weak var themeCell: UITableViewCell!
    @IBOutlet weak var privateKeyCell: UITableViewCell!
    @IBOutlet weak var watchOnlyCell: UITableViewCell!
    @IBOutlet weak var currencyCell: UITableViewCell!
    @IBOutlet weak var contactCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!

    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var themeView: UIView!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var watchOnlyLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!

    var netString = UserDefaultsManager.network == .test ? "Network: Test Network": "Network: Main Network" {
        didSet {
            self.setNetLabel()
        }
    }

    var themeString = UserDefaultsManager.theme == .light ? "Theme: Classic": "Theme: Dark" {
        didSet {
            self.setThemeLabel()
        }
    }

    func setNetLabel() {
        guard let label = networkCell.viewWithTag(1) as? UILabel else {
            fatalError("Undefined behavior with table view")
        }
        DispatchQueue.main.async { label.text = self.netString }
    }

    func setThemeLabel() {
        guard let label = themeCell.viewWithTag(1) as? UILabel else {
            fatalError("Undefined behavior with table view")
        }
        DispatchQueue.main.async { label.text = self.themeString }
    }

    func setThemedElements() {
        let themedTitleLabels = [privateKeyLabel, watchOnlyLabel, netLabel, contactLabel, themeLabel, currencyLabel, logoutLabel, versionLabel]
        let themedCells = [networkCell, themeCell, privateKeyCell, watchOnlyCell, currencyCell, contactCell, logoutCell]
        for cell in themedCells {
            cell?.contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        }

        for label in themedTitleLabels {
            label?.theme_textColor = O3Theme.titleColorPicker
        }
        versionLabel?.theme_textColor = O3Theme.lightTextColorPicker
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
    }

    override func viewDidLoad() {
        setThemedElements()
        applyNavBarTheme()
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "angle-up"), style: .plain, target: self, action: #selector(SettingsMenuTableViewController.maximize(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        showPrivateKeyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPrivateKey)))
        contactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMail)))
        themeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTheme)))
        setNetLabel()
        setThemeLabel()

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = String(format: "Version: %@", version)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyLabel.text = "Currency: " + UserDefaultsManager.referenceFiatCurrency.rawValue.uppercased()
    }

    @objc func maximize(_ sender: Any) {
        maximizeToFullScreen()
    }

    @objc func changeTheme() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let lightThemeAction = UIAlertAction(title: "Classic Theme", style: .default) { _ in
            SwiftTheme.ThemeManager.setTheme(index: 0)
            UserDefaultsManager.theme = .light
            self.themeString = "Theme: Classic"
        }

        let darkThemeAction = UIAlertAction(title: "Dark Theme", style: .default) { _ in
            SwiftTheme.ThemeManager.setTheme(index: 1)
            UserDefaultsManager.theme = .dark
            self.themeString = "Theme: Dark"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }

        optionMenu.addAction(lightThemeAction)
        optionMenu.addAction(darkThemeAction)
        optionMenu.addAction(cancelAction)

        optionMenu.popoverPresentationController?.sourceView = themeView
        present(optionMenu, animated: true, completion: nil)
    }

    @objc func sendMail() {
        let email = "support@o3.network"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
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

    func logoutTapped(_ sender: Any) {

    }

    //properly implement cell did tap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 6 {
            OzoneAlert.confirmDialog(message: "Log out?", cancelTitle: "Cancel", confirmTitle: "Log out", didCancel: {

            }, didConfirm: {
                Authenticated.account = nil
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
            })

        }
    }
}
