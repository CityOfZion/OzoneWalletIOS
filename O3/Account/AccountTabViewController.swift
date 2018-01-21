//
//  AccountTabViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import Tabman_Carthage
import Pageboy

class AccountTabViewController: TabmanViewController, PageboyViewControllerDataSource {

    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hideHairline()

        let accountAssetViewController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AccountAssetTableViewController")

           let transactionHistory = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "TransactionHistoryTableViewController")
          let contactsViewController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ContactsTableViewController")

        self.viewControllers.append(accountAssetViewController)
        self.viewControllers.append(transactionHistory)
        self.viewControllers.append(contactsViewController)

        self.dataSource = self

        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = UserDefaultsManager.theme.primaryColor
            appearance.layout.edgeInset = 0
            appearance.text.font = ThemeManager.topTabbarItemFont
            appearance.style.background = .solid(color:  UserDefaultsManager.theme.backgroundColor)
        })
        self.bar.location = .top
        self.bar.style = .buttonBar
        self.bar.items = [Item(title: "ASSETS"),
                          Item(title: "TRANSACTIONS"),
                          Item(title: "CONTACTS")]

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

}
