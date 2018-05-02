//
//  SendCompleteViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/20/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class SendCompleteViewController: UIViewController {
    @IBOutlet weak var completeImage: UIImageView!
    @IBOutlet weak var completeTitle: UILabel!
    @IBOutlet weak var completeSubtitle: UILabel!
    var transactionSucceeded: Bool!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle(SendStrings.close, for: UIControlState())

        if transactionSucceeded {
            completeImage.image = #imageLiteral(resourceName: "checked")
            completeTitle.text = SendStrings.transactionSucceededTitle
            completeSubtitle.text = SendStrings.transactionSucceededSubtitle
        } else {
            completeImage.image = #imageLiteral(resourceName: "sad")
            completeTitle.text = SendStrings.transactionFailedTitle
            completeSubtitle.text = SendStrings.transactionFailedSubtitle
        }
    }
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
