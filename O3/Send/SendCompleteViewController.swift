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

    override func viewDidLoad() {
        super.viewDidLoad()
        if transactionSucceeded {
            completeImage.image = #imageLiteral(resourceName: "checked")
            completeTitle.text = "Created Transaction Successfully"
            completeSubtitle.text = "Once your transaction has been confirmed it will appear in your transaction histoty"
        } else {
            completeImage.image = #imageLiteral(resourceName: "sad")
            completeTitle.text = "Something Went Wrong"
            completeSubtitle.text = "Please try to send your transaction again later"
        }
    }
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
