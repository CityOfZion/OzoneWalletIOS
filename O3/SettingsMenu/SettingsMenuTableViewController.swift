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
import KeychainAccess
import WebBrowser

class SettingsMenuTableViewController: UITableViewController, HalfModalPresentable, WebBrowserDelegate {
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
    @IBOutlet weak var supportCell: UITableViewCell!

    @IBOutlet weak var supportView: UIView!
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
    @IBOutlet weak var supportLabel: UILabel!

    var themeString = UserDefaultsManager.themeIndex == 0 ? SettingsStrings.classicTheme: SettingsStrings.darkTheme {
        didSet {
            self.setThemeLabel()
        }
    }

    func setThemeLabel() {
        guard let label = themeCell.viewWithTag(1) as? UILabel else {
            fatalError("Undefined behavior with table view")
        }
        DispatchQueue.main.async { label.text = self.themeString }
    }

    func setThemedElements() {
        let themedTitleLabels = [privateKeyLabel, watchOnlyLabel, netLabel, contactLabel, themeLabel, currencyLabel, logoutLabel, versionLabel, supportLabel]
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
        setLocalizedStrings()
        applyNavBarTheme()
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "angle-up"), style: .plain, target: self, action: #selector(SettingsMenuTableViewController.maximize(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        showPrivateKeyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPrivateKey)))
        contactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMail)))
        supportView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSupportForum)))
        themeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTheme)))
        setThemeLabel()

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = String(format: SettingsStrings.versionLabel, version)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyLabel.text = String(format: SettingsStrings.currencyTitle, UserDefaultsManager.referenceFiatCurrency.rawValue.uppercased())
    }

    @objc func maximize(_ sender: Any) {
        maximizeToFullScreen()
    }

    @objc func changeTheme() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let lightThemeAction = UIAlertAction(title: SettingsStrings.classicTheme, style: .default) { _ in
            UserDefaultsManager.themeIndex = 0
            ThemeManager.setTheme(index: 0)
            self.themeString = SettingsStrings.classicTheme
        }

        let darkThemeAction = UIAlertAction(title: SettingsStrings.darkTheme, style: .default) { _ in
            UserDefaultsManager.themeIndex = 1
            ThemeManager.setTheme(index: 1)
            self.themeString = SettingsStrings.darkTheme
        }

        let cancelAction = UIAlertAction(title: OzoneAlert.cancelNegativeConfirmString, style: .cancel) { _ in
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

    @objc func openSupportForum() {
        let webBrowserViewController = WebBrowserViewController()

        webBrowserViewController.delegate = self
        webBrowserViewController.isToolbarHidden = true
        webBrowserViewController.title = ""
        webBrowserViewController.isShowURLInNavigationBarWhenLoading = false
        webBrowserViewController.barTintColor = UserDefaultsManager.themeIndex == 0 ? Theme.light.backgroundColor: Theme.dark.backgroundColor
        webBrowserViewController.tintColor = Theme.light.primaryColor
        webBrowserViewController.isShowPageTitleInNavigationBar = false
        webBrowserViewController.loadURLString("https://community.o3.network")
        maximizeToFullScreen(allowReverse: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(webBrowserViewController, animated: true)
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
                    .authenticationPrompt(SettingsStrings.authenticate)
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

    func performLogoutCleanup() {
        O3Cache.clear()
        try? Keychain(service: "network.o3.neo.wallet").remove("ozonePrivateKey")
        Authenticated.account = nil
        UserDefaultsManager.o3WalletAddress = nil
        NotificationCenter.default.post(name: Notification.Name("loggedOut"), object: nil)
        self.dismiss(animated: false)
        let o3tab =  UIApplication.shared.keyWindow?.rootViewController as? O3TabBarController

        //Chance these aren't nil yet which leads to reference cycke
        o3tab?.halfModalTransitioningDelegate?.viewController = nil
        o3tab?.halfModalTransitioningDelegate?.presentingViewController = nil
        o3tab?.halfModalTransitioningDelegate?.interactionController = nil
        o3tab?.halfModalTransitioningDelegate = nil
    }

    //properly implement cell did tap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 7 {
            OzoneAlert.confirmDialog(message: SettingsStrings.logoutWarning, cancelTitle: OzoneAlert.cancelNegativeConfirmString, confirmTitle: SettingsStrings.logout, didCancel: {

            }, didConfirm: {
                self.performLogoutCleanup()
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()

            })

        }
    }

    func setLocalizedStrings() {
        self.title = SettingsStrings.settingsTitle
        privateKeyLabel.text = SettingsStrings.privateKeyTitle
        watchOnlyLabel.text = SettingsStrings.watchOnlyTitle
        netLabel.text = SettingsStrings.networkTitle
        themeLabel.text = SettingsStrings.themeTitle
        currencyLabel.text = SettingsStrings.currencyTitle + ": " + UserDefaultsManager.referenceFiatCurrency.rawValue.uppercased()
        contactLabel.text = SettingsStrings.contactTitle
        logoutLabel.text = SettingsStrings.logout
        supportLabel.text = SettingsStrings.supportTitle
        versionLabel.text = SettingsStrings.versionLabel

    }
}
