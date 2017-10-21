//
//  NetworkTypeCell.swift
//  O3
//
//  Created by Andrei Terentiev on 10/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class NetworkTypeCell: UITableViewCell {
    @IBOutlet weak var networkTypeButton: UIButton!
    @IBOutlet weak var seedTypeButton: UIButton!
    weak var delegate: NetworkTableViewController?

    @IBAction func networkTypeTapped(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let testNetAction = UIAlertAction(title: "Test Network", style: .default) { _ in
            if !UserDefaultsManager.useDefaultSeed {
                OzoneAlert.confirmDialog(message: "This action will revert you to the defualt seed configuration", cancelTitle: "Cancel", confirmTitle: "Confirm", didCancel: {}) {
                    UserDefaultsManager.network = .test
                    UserDefaultsManager.useDefaultSeed = true
                    DispatchQueue.main.async {
                        self.networkTypeButton.setTitle("Test Network", for: UIControlState())
                        self.seedTypeButton.setTitle("Default", for: UIControlState())
                    }
                }
            } else {
                UserDefaultsManager.network = .test
                self.networkTypeButton.setTitle("Test Network", for: UIControlState())
            }
            self.delegate?.updateNodeData()
        }

        let mainNetAction = UIAlertAction(title: "Main Network", style: .default) { _ in
            if !UserDefaultsManager.useDefaultSeed {
                OzoneAlert.confirmDialog(message: "This action will revert you to the defualt seed configuration", cancelTitle: "Cancel", confirmTitle: "Confirm", didCancel: {}) {
                    UserDefaultsManager.network = .main
                    UserDefaultsManager.useDefaultSeed = true
                    DispatchQueue.main.async {
                        self.networkTypeButton.setTitle("Main Network", for: UIControlState())
                        self.seedTypeButton.setTitle("Default", for: UIControlState())
                    }
                }
            } else {
                UserDefaultsManager.network = .main
                self.networkTypeButton.setTitle("Main Network", for: UIControlState())
            }
            self.delegate?.updateNodeData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }

        optionMenu.addAction(testNetAction)
        optionMenu.addAction(mainNetAction)
        optionMenu.addAction(cancelAction)

        delegate?.present(optionMenu, animated: true, completion: nil)

    }

    @IBAction func seedTypeTapped(_ sender: Any) {
        if UserDefaultsManager.useDefaultSeed {
            OzoneAlert.alertDialog(message: "If you wish to use a custom seed please select one from the list", dismissTitle: "OK") {}
        } else {
            OzoneAlert.confirmDialog(message: "Are you sure you want to revert to the default seed configuration?", cancelTitle: "Cancel", confirmTitle: "Confirms", didCancel: { }) {
                UserDefaultsManager.useDefaultSeed = true
                DispatchQueue.main.async {  self.seedTypeButton.setTitle("Default", for: UIControlState()) }
            }
        }
    }
}
