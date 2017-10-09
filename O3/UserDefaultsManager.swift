//
//  UserDefaultsManager.swift
//  O3
//
//  Created by Andrei Terentiev on 10/9/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import NeoSwift

class UserDefaultsManager {

    private static let networkKey = "networkKey"

    static var network: Network {
        get {
            let stringValue = UserDefaults.standard.string(forKey: networkKey)!
            return Network(rawValue: stringValue)!
        }
        set {
            Authenticated.account?.network = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: networkKey)
            NotificationCenter.default.post(name: Notification.Name("ChangedNetwork"), object: nil)
        }
    }

}
