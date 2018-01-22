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

class O3TabBarController: UITabBarController {
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    func addThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAppearance), name: Notification.Name("ChangedTheme"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ChangedTheme"), object: nil)
    }

    @objc func updateAppearance(_ sender: Any?) {
        DispatchQueue.main.async {
            if UserDefaultsManager.theme == .dark {
                self.tabBar.barStyle = .black
            } else {
                self.tabBar.barStyle = .default
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addThemeObserver()

        updateAppearance(nil)
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

        menuButton.backgroundColor = UserDefaultsManager.theme.lightTextColor
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

    @IBAction func tappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc func menuButtonAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let scan = UIAlertAction(title: "Scan QR code", style: .default) { _ in

        }
        actionSheet.addAction(scan)

        let send = UIAlertAction(title: "Send", style: .default) { _ in
            self.sendTapped()
        }
        actionSheet.addAction(send)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }

    @objc func tappedSettingsTab() {
        self.performSegue(withIdentifier: "segueToSettings", sender: nil)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.index(of: item) else { return }
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
