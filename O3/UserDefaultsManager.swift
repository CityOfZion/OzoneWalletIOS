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

    private static let useDefaultSeedKey = "usedDefaultSeedKey"
    static var useDefaultSeed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: useDefaultSeedKey)
        }
        set {
            if newValue {
                Neo.client.getBestNode { result in
                    switch result {
                    case .failure:
                        return
                    case .success(let node):
                        UserDefaults.standard.set(newValue, forKey: useDefaultSeedKey)
                        UserDefaultsManager.seed = node
                    }
                }
            } else {
                UserDefaults.standard.set(newValue, forKey: useDefaultSeedKey)
                UserDefaults.standard.synchronize()
            }
        }
    }

    private static let seedKey = "seedKey"
    static var seed: String {
        get {
            return UserDefaults.standard.string(forKey: seedKey)!
        }
        set {
            Neo.client.seed = newValue
            UserDefaults.standard.set(newValue, forKey: seedKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name("ChangedNetwork"), object: nil)
        }
    }

    private static let selectedThemeKey = "selectedThemeKey"
    static var theme: Theme {
        get {
            let stringValue = UserDefaults.standard.string(forKey: selectedThemeKey)!
            return Theme(rawValue: stringValue)!
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: selectedThemeKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name("ChangedTheme"), object: nil)
        }
    }

    private static let launchedBeforeKey = "launchedBeforeKey"
    static var launchedBefore: Bool {
        get {
            let value = UserDefaults.standard.bool(forKey: launchedBeforeKey)
            return value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: launchedBeforeKey)
            UserDefaults.standard.synchronize()
        }
    }

    private static let o3WalletAddressKey = "o3WalletAddressKey"
    static var o3WalletAddress: String? {
        get {
            let stringValue = UserDefaults.standard.string(forKey: o3WalletAddressKey)
            return stringValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: o3WalletAddressKey)
            UserDefaults.standard.synchronize()
        }
    }
}
