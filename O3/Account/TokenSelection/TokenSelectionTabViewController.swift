//
//  TokenSelectionViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import Tabman
import Pageboy
import SwiftTheme

class TokenSelectionTabViewController: TabmanViewController, PageboyViewControllerDataSource {
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let nep5TokensViewController = UIStoryboard(name: "TokenSelection", bundle: nil).instantiateViewController(withIdentifier: "nep5SelectionCollectionViewController")
        let nftTokensViewController = UIStoryboard(name: "TokenSelection", bundle: nil).instantiateViewController(withIdentifier: "nftSelectionViewController")
        self.viewControllers.append(nep5TokensViewController)
        self.viewControllers.append(nftTokensViewController)
        self.dataSource = self
        applyNavBarTheme()
        setTabmanAppearance()
        setLocalizedStrings()

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

    // MARK: Theming and Localizations
    func setTabmanAppearance() {
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = UserDefaultsManager.themeIndex == 0 ? Theme.light.primaryColor : Theme.dark.primaryColor
            appearance.state.color = UserDefaultsManager.themeIndex == 0 ? Theme.light.lightTextColor : Theme.dark.lightTextColor
            appearance.text.font = O3Theme.topTabbarItemFont
            appearance.layout.edgeInset = 0
            appearance.style.background = .solid(color: ThemeManager.currentThemeIndex == 0 ? Theme.light.backgroundColor : Theme.dark.backgroundColor)
        })
        self.bar.location = .top
        self.bar.style = .buttonBar
    }

    @objc func tappedClose(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tokenSelectorDismissed"), object: nil)
        DispatchQueue.main.async { self.dismiss(animated: true) }
    }

    func setLocalizedStrings() {
        bar.items = [Item(title: TokenSelectionStrings.NEP5),
                     Item(title: TokenSelectionStrings.artsAndCollectibles)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "times"), style: .plain, target: self, action: #selector(tappedClose(_:)))
    }
}
