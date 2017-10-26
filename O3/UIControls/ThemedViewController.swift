//
//  ThemedTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 10/22/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class ThemedViewController: UIViewController {
    var themedPrimaryButtons = [UIButton]()
    var themedLabels =  [UILabel]()
    var themedTableViews = [UITableView]()
    var themedCollectionViews = [UICollectionView]()
    var themedTransparentButtons = [UIButton]()
    var themedBackgroundViews = [UIView]()

    func addThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changedTheme), name: Notification.Name("ChangedTheme"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ChangedTheme"), object: nil)
    }

    @objc func changedTheme(_ sender: Any) {
        applyTheme()
        for tableView in themedTableViews {
            tableView.reloadData()
        }
        for collection in themedCollectionViews {
            collection.reloadData()
        }
    }

    func setupNavBar() {
        DispatchQueue.main.async {
            UIApplication.shared.statusBarStyle = UserDefaultsManager.theme.statusBarStyle
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationController?.hideHairline()
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            self.navigationController?.navigationBar.barTintColor = UserDefaultsManager.theme.backgroundColor

            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.backgroundColor = UserDefaultsManager.theme.backgroundColor
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UserDefaultsManager.theme.titleTextColor,
                                                                        NSAttributedStringKey.font:
                                                                        ThemeManager.largeTitleFont]
        }
    }

    func applyTheme() {
        addThemeObserver()
        setupNavBar()
        DispatchQueue.main.async {
            self.view.backgroundColor = UserDefaultsManager.theme.backgroundColor

            for button in self.themedPrimaryButtons {
                button.backgroundColor = UserDefaultsManager.theme.backgroundColor
                button.setTitleColor(UIColor.white, for: UIControlState())
            }

            for label in self.themedLabels {
                label.textColor = UserDefaultsManager.theme.textColor
            }

            for tableView in self.themedTableViews {
                tableView.separatorColor = UserDefaultsManager.theme.seperatorColor
                tableView.tableHeaderView?.backgroundColor = UserDefaultsManager.theme.backgroundColor
                tableView.tableFooterView?.backgroundColor = UserDefaultsManager.theme.backgroundColor
                tableView.backgroundColor = UserDefaultsManager.theme.backgroundColor
                for cell in tableView.visibleCells {
                    cell.contentView.backgroundColor = UserDefaultsManager.theme.backgroundColor
                    cell.backgroundColor = UserDefaultsManager.theme.backgroundColor
                }
            }

            for collection in self.themedCollectionViews {
                collection.backgroundColor = UserDefaultsManager.theme.backgroundColor
                for cell in collection.visibleCells {
                    cell.contentView.backgroundColor = UserDefaultsManager.theme.backgroundColor
                }
            }

            for button in self.themedTransparentButtons {
                button.backgroundColor = UserDefaultsManager.theme.backgroundColor
                button.setTitleColor(UserDefaultsManager.theme.primaryColor, for: UIControlState())
            }

            for view in self.themedBackgroundViews {
                view.backgroundColor = UserDefaultsManager.theme.backgroundColor
            }
        }
    }

    override func viewDidLoad() {
        applyTheme()
        super.viewDidLoad()
    }
}
