//
//  UIViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
import SwiftTheme

extension UIViewController {
    func presentFromEmbedded(_ toPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let navigationController = self as? UINavigationController {
            navigationController.topViewController?.presentFromEmbedded(toPresent, animated: flag, completion: completion)
        } else if let tabBarController = self as? UITabBarController {
            tabBarController.selectedViewController?.presentFromEmbedded(toPresent, animated: flag, completion: completion)
        } else if let presentedViewController = presentedViewController {
            presentedViewController.presentFromEmbedded(toPresent, animated: flag, completion: completion)
        } else {
            DispatchQueue.main.async { self.present(toPresent, animated: flag, completion: completion) }
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func applyNavBarTheme() {
        DispatchQueue.main.async {
            UIApplication.shared.theme_setStatusBarStyle(ThemeStatusBarStylePicker(styles: Theme.light.statusBarStyle, Theme.dark.statusBarStyle), animated: true)
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationController?.hideHairline()
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            self.navigationController?.navigationBar.theme_barTintColor = ThemeColorPicker(colors: Theme.light.backgroundColor.hexString(false), Theme.dark.backgroundColor.hexString(false))
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.theme_backgroundColor = ThemeColorPicker(colors: Theme.light.backgroundColor.hexString(false), Theme.dark.backgroundColor.hexString(false))
            self.navigationController?.navigationBar.theme_largeTitleTextAttributes = ThemeDictionaryPicker(arrayLiteral: [
                NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
                NSAttributedStringKey.font.rawValue: ThemeManager.largeTitleFont],
                [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                 NSAttributedStringKey.font.rawValue: ThemeManager.largeTitleFont])
            self.navigationController?.navigationBar.theme_titleTextAttributes = ThemeDictionaryPicker(arrayLiteral: [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
                NSAttributedStringKey.font.rawValue: ThemeManager.navBarTitle],
                [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                 NSAttributedStringKey.font.rawValue: ThemeManager.navBarTitle])
        }
    }
}
