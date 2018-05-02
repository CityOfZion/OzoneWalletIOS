//
//  NftTokenViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class NftSelectionViewController: UIViewController {
    @IBOutlet weak var animationView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let lottieView = LOTAnimationView(name: "empty_status")
        lottieView.frame = animationView.bounds
        lottieView.loopAnimation = true
        animationView.addSubview(lottieView)
        lottieView.play()

    }
}
