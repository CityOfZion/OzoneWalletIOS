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
    static var account: Account?
    static var watchOnlyAddresses: [String]? //watch only addresses
    static var contacts: [(String, String)]?
}

struct Theme {
    struct Light {
        static let cornerRadius: CGFloat = 6.0
        static let borderWidth: CGFloat = 1.0
        static let borderColor = UIColor(named: "borderColor")!
        static let textColor = UIColor(named: "textColor")!
        static let primary = UIColor(named: "lightThemePrimary")!
        static let grey = UIColor(named: "grey")!
        static let lightgrey = UIColor(named: "lightGreyTransparent")!
        static let red = UIColor(named: "lightThemeRed")!
        static let orange = UIColor(named: "lightThemeOrange")!
        static let green = UIColor(named: "lightThemeGreen")!
        static let smallText = UIFont(name: "Avenir-Book", size: 12)
        static let barButtonItemFont = UIFont(name: "Avenir-Heavy", size: 16)
    }
}

struct Neo {
    static var isTestnet = true
    static var client: NeoClient {
        if isTestnet {
            return NeoClient(seed: "http://test1.cityofzion.io:8880")
        }
        return NeoClient(seed: "http://seed1.cityofzion.io:8080")
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
    case fiveMinutes = 5
    case fifteenMinutes = 15
    case thirtyMinutes = 30
    case sixtyMinutes = 60
    case oneDay = 1440
    case all = 1500
}

enum PortfolioType {
    case readOnly
    case writable
    case readOnlyAndWritable
}
