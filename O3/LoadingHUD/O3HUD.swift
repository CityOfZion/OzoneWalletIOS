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
    @IBOutlet weak var hudContainer: UIView!
    public static let sharedInstance = UIStoryboard(name: "O3HUD", bundle: nil).instantiateViewController(withIdentifier: "O3HUD")

    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "fidget"))
        hudContainer.embed(imageView)
        view.bringSubview(toFront: hudContainer)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { self.hudContainer.startRotating() }

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
