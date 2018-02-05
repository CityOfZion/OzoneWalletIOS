//
//  Global.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import NeoSwift
import UIKit

struct Authenticated {
    static var account: Account? {
        didSet {
            if account != nil {
                //store current address in user default
                UserDefaultsManager.o3WalletAddress = account?.address
            }
        }
    }
    static var watchOnlyAddresses: [String]? //watch only addresses
    static var contacts: [(String, String)]?
}

class Neo {
    static var sharedTest: NeoClient?
    static var sharedMain: NeoClient?

    static var client: NeoClient {
        if sharedTest == nil {
            sharedTest = NeoClient.sharedTest
        }
        if sharedMain == nil {
            sharedMain = NeoClient.sharedMain
        }

        return sharedMain!
    }
}

struct Precision {
    static let usd = 2
    static let btc = 8
    static let gas = 8
    static let percent = 2
}

enum Currency: String {
    case btc
    case usd
}

enum PriceInterval: String {
    case sixHours = "6h"
    case oneDay = "24h"
    case oneWeek = "1w"
    case oneMonth = "1m"
    case threeMonths = "3m"
    case all = "all"

    func minuteValue() -> Int {
        switch rawValue {
        case "6h": return 5
        case "24h": return 20
        case "1w": return 140
        case "1m": return 560
        case "3m": return 1680
        case "all": return 2000
        default: return 0
        }
    }
}

enum PortfolioType {
    case readOnly
    case writable
    case readOnlyAndWritable
}
