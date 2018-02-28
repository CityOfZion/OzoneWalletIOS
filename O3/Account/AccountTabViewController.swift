//
//  AccountTabViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import DeckTransition
import SwiftTheme

class AccountTabViewController: TabmanViewController, PageboyViewControllerDataSource {

    var viewControllers: [UIViewController] = []

    func addThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changedTheme), name: Notification.Name(rawValue: ThemeUpdateNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: ThemeUpdateNotification), object: nil)
    }

    @objc func changedTheme(_ sender: Any) {
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = UserDefaultsManager.theme.primaryColor
            appearance.state.color = UserDefaultsManager.theme.lightTextColor
            appearance.layout.edgeInset = 0
            appearance.text.font = O3Theme.topTabbarItemFont
            appearance.style.background = .solid(color: ThemeManager.currentThemeIndex == 0 ? Theme.light.backgroundColor : Theme.dark.backgroundColor)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addThemeObserver()

        let accountAssetViewController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AccountAssetTableViewController")
        let transactionHistory = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "TransactionHistoryTableViewController")
        let contactsViewController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ContactsTableViewController")

        self.viewControllers.append(accountAssetViewController)
        self.viewControllers.append(transactionHistory)
        self.viewControllers.append(contactsViewController)

        self.dataSource = self

        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = UserDefaultsManager.theme.primaryColor
            appearance.state.color = UserDefaultsManager.theme.lightTextColor
            appearance.text.font = O3Theme.topTabbarItemFont
            appearance.layout.edgeInset = 0
            appearance.style.background = .solid(color: ThemeManager.currentThemeIndex == 0 ? Theme.light.backgroundColor : Theme.dark.backgroundColor)
        })
        self.bar.location = .top
        self.bar.style = .buttonBar
        self.bar.items = [Item(title: "ASSETS"),
                          Item(title: "TRANSACTIONS"),
                          Item(title: "CONTACTS")]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "qrCode-button"), style: .plain, target: self, action: #selector(myAddressTapped(_:)))
        self.view.theme_backgroundColor = O3Theme.backgroundColorPicker

    }

    override func viewWillAppear(_ animated: Bool) {
        applyNavBarTheme()
        super.viewWillAppear(animated)
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    @objc func myAddressTapped(_ sender: Any) {
        let modal = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MyAddressNavigationController")

        let transitionDelegate = DeckTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }

}
