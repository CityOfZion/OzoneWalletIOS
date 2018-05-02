//
//  O3TabBar.swift
//  O3
//
//  Created by Andrei Terentiev on 9/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import DeckTransition
import SwiftTheme
import Crashlytics

class O3TabBarController: UITabBarController {
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.theme_barStyle = O3Theme.tabBarStylePicker
        tabBar.items?[4].image = UIImage(named: "cog")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[4].title = ""
        tabBar.items?[4].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        tabBar.items?[4].isEnabled = true

        let tabOverrideView = UIView(frame: tabBar.subviews[4].frame)
        tabOverrideView.isUserInteractionEnabled = true
        tabOverrideView.backgroundColor = UIColor.clear

        let button = UIButton(frame: tabOverrideView.frame)
        button.addTarget(self, action: #selector(tappedSettingsTab), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        tabOverrideView.embed(button)
        self.tabBar.addSubview(tabOverrideView)
        setupMiddleButton()
    }

    func setupMiddleButton() {

        tabBar.items?[2].isEnabled = false
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: tabBar.bounds.size.height - 8, height: tabBar.bounds.size.height - 8))

        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = (tabBar.bounds.height - menuButtonFrame.height) - 4
        menuButtonFrame.origin.x = tabBar.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.theme_backgroundColor = O3Theme.lightTextColorPicker
        menuButton.tintColor = UIColor.white
        menuButton.layer.cornerRadius = menuButtonFrame.height/2

        menuButton.setImage(UIImage(named: "plus-noborder"), for: .normal)
        menuButton.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action: #selector(menuButtonAction(_:)), for: .touchUpInside)

        tabBar.addSubview(menuButton)
        tabBar.layoutIfNeeded()
    }

    func sendTapped() {
        let modal = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendTableViewController")
        let nav = WalletHomeNavigationController(rootViewController: modal)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .automatic
        modal.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "times"), style: .plain, target: self, action: #selector(tappedLeftBarButtonItem(_:)))
        let transitionDelegate = DeckTransitioningDelegate()
        nav.transitioningDelegate = transitionDelegate
        nav.modalPresentationStyle = .custom
        present(nav, animated: true, completion: nil)
    }

    func receivedTapped() {
        let modal = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MyAddressNavigationController")

        let transitionDelegate = DeckTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
    }

    func tokenSaleTapped() {
        let modal = UIStoryboard(name: "TokenSale", bundle: nil).instantiateInitialViewController() as? UINavigationController
        present(modal!, animated: true, completion: nil)
    }

    @IBAction func tappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func unwindToTabbar(segue: UIStoryboardSegue) {
    }

    @objc func menuButtonAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let send = UIAlertAction(title: TabbarStrings.sendTitle, style: .default) { _ in
            self.sendTapped()
        }
        actionSheet.addAction(send)

        let receive = UIAlertAction(title: TabbarStrings.receiveTitle, style: .default) { _ in
            self.receivedTapped()
        }
        actionSheet.addAction(receive)

        let tokenSale = UIAlertAction(title: TabbarStrings.tokenSalesTitle, style: .default) { _ in
            self.tokenSaleTapped()
        }
        if O3Cache.gasBalance() > 0 || O3Cache.neoBalance() > 0 {
            actionSheet.addAction(tokenSale)
        }

        let cancel = UIAlertAction(title: OzoneAlert.cancelNegativeConfirmString, style: .cancel) { _ in

        }
        actionSheet.addAction(cancel)
        actionSheet.popoverPresentationController?.sourceView = sender
        present(actionSheet, animated: true, completion: nil)
    }

    @objc func tappedSettingsTab() {
       self.performSegue(withIdentifier: "segueToSettings", sender: nil)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.index(of: item) else { return }
        let tabTappedMessages = ["Portfolio", "Wallet", "Center Button", "News", "Settings" ]
        Answers.logCustomEvent(withName: "Tab Tapped",
                               customAttributes: ["Tab Name": tabTappedMessages[index]])

        if index == 4 {
           self.performSegue(withIdentifier: "segueToSettings", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)

        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
    }
}
