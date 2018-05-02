//
//  O3Cache.swift
//  O3
//
//  Created by Andrei Terentiev on 4/16/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import Cache

class O3Cache {

    static func clear() {
        if let storage = try? Storage(diskConfig: DiskConfig(name: "O3")) {
            try? storage.removeObject(forKey: "gasBalance")
            try? storage.removeObject(forKey: "neoBalance")
        }
    }

    static func setNEOForSession(neoBalance: Int) {
        if let storage = try? Storage(diskConfig: DiskConfig(name: "O3")) {
            try? storage.setObject(neoBalance, forKey: "neoBalance")
        }
    }

    static func setGASForSession(gasBalance: Double) {
        if let storage = try? Storage(diskConfig: DiskConfig(name: "O3")) {
            try? storage.setObject(gasBalance, forKey: "gasBalance")
        }
    }

    static func gasBalance() -> Double {
        var cachedGASBalance = 0.0
        if let storage =  try? Storage(diskConfig: DiskConfig(name: "O3")) {
            cachedGASBalance = (try? storage.object(ofType: Double.self, forKey: "gasBalance")) ?? 0.0
        }
        return cachedGASBalance
    }

    static func neoBalance() -> Int {
        var cachedNEOBalance = 0
        if let storage =  try? Storage(diskConfig: DiskConfig(name: "O3")) {
            cachedNEOBalance = (try? storage.object(ofType: Int.self, forKey: "neoBalance")) ?? 0
        }
        return cachedNEOBalance
    }
}
