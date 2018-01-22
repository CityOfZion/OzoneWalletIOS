//
//  loadingHUD.swift
//  O3
//
//  Created by Andrei Terentiev on 10/8/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class O3HUD: UIViewController {
    public static let sharedInstance = UIStoryboard(name: "O3HUD", bundle: nil).instantiateViewController(withIdentifier: "O3HUD")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func start() {
        sharedInstance.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.presentFromEmbedded(sharedInstance, animated: true) {}
        }
    }

    static func stop(completed: @escaping() -> Void) {
        DispatchQueue.main.async {
            sharedInstance.dismiss(animated: true) {
                completed()
            }
        }
    }
}
