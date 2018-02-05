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

enum PriceInterval: Int {
    case sixHours = 5
    case oneDay = 20
    case oneWeek = 140
    case oneMonth = 560
    case threeMonths = 1680
    case all = 2000
}

enum PortfolioType {
    case readOnly
    case writable
    case readOnlyAndWritable
}
