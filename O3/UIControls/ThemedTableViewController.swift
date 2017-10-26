//
//  ThemedTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 10/22/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

//TODO: Combine this with the themed UIViewController...too tired to figure it out now
class ThemedTableViewController: UITableViewController {
    var themedPrimaryButtons = [UIButton]()
    var themedLabels = [UILabel]()
    var themedTitleLabels = [UILabel]()
    var themedCollectionViews = [UICollectionView]()
    var themedTransparentButtons = [UIButton]()
    var themedBackgroundViews = [UIView]()
    var themedTextFields = [UITextField]()
    var themedTextViews = [UITextView]()

    func addThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changedTheme), name: Notification.Name("ChangedTheme"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ChangedTheme"), object: nil)
    }

    @objc func changedTheme(_ sender: Any) {
        applyTheme()
        tableView.reloadData()
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
            self.tableView.backgroundColor = UserDefaultsManager.theme.backgroundColor
            for cell in self.tableView.visibleCells {
                cell.contentView.backgroundColor = UserDefaultsManager.theme.backgroundColor
            }
            for button in self.themedPrimaryButtons {
                button.backgroundColor = UserDefaultsManager.theme.backgroundColor
                button.setTitleColor(UIColor.white, for: UIControlState())
            }

            for label in self.themedLabels {
                label.textColor = UserDefaultsManager.theme.textColor
            }

            for label in self.themedTitleLabels {
                label.textColor = UserDefaultsManager.theme.titleTextColor
            }

            self.tableView.tableHeaderView?.backgroundColor = UserDefaultsManager.theme.backgroundColor
            self.tableView.tableFooterView?.backgroundColor = UserDefaultsManager.theme.backgroundColor
            self.tableView.backgroundColor = UserDefaultsManager.theme.backgroundColor
            self.tableView.separatorColor = UserDefaultsManager.theme.seperatorColor
            for cell in self.tableView.visibleCells {
                cell.contentView.backgroundColor = UserDefaultsManager.theme.backgroundColor
                cell.backgroundColor = UserDefaultsManager.theme.backgroundColor
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

            for textField in self.themedTextFields {
                textField.backgroundColor = UserDefaultsManager.theme.textFieldBackgroundColor
                textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UserDefaultsManager.theme.textFieldPlaceHolderColor ])
                textField.textColor = UserDefaultsManager.theme.textFieldTextColor
            }

            for textView in self.themedTextViews {
                textView.backgroundColor = UserDefaultsManager.theme.backgroundColor
            }
        }
    }

    override func viewDidLoad() {
        applyTheme()
        super.viewDidLoad()
    }
}
