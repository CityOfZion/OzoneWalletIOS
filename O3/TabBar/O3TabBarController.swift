//
//  O3TabBar.swift
//  O3
//
//  Created by Andrei Terentiev on 9/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class O3TabBarController: UITabBarController {
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.items?[2].image = UIImage(named:"cog")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[2].title = ""
        tabBar.items?[2].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        tabBar.items?[2].isEnabled = true

        let tabOverrideView = UIView(frame:tabBar.subviews[2].frame)
        tabOverrideView.isUserInteractionEnabled = true
        tabOverrideView.backgroundColor = UIColor.clear

        let button = UIButton(frame: tabOverrideView.frame)
        button.addTarget(self, action: #selector(tappedSettingsTab), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        tabOverrideView.embed(button)
        self.tabBar.addSubview(tabOverrideView)
    }

    @objc func tappedSettingsTab() {
        self.performSegue(withIdentifier: "segueToSettings", sender: nil)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.index(of: item) else { return }
        if index == 2 {
            self.performSegue(withIdentifier: "segueToSettings", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)

        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
    }
}
