//
//  NEOAsset.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/23/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import NeoSwift
import Cache

enum AssetType: Int, Codable {
    case nativeAsset = 0
    case nep5Token
}

extension TransferableAsset {

    var formattedBalanceString: String {
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = self.decimal
        amountFormatter.numberStyle = .decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true
        return String(format: "%@", amountFormatter.string(from: NSDecimalNumber(decimal: self.balance))!)
    }
}

struct TransferableAsset: Codable {
    var assetID: String!
    var name: String!
    var symbol: String!
    var assetType: AssetType! = AssetType.nativeAsset //default to this
    var decimal: Int!
    var balance: Decimal! = 0.0
}

extension TransferableAsset {
    static func NEO() -> TransferableAsset {
        return TransferableAsset(
            assetID: NeoSwift.AssetId.neoAssetId.rawValue,
            name: "NEO",
            symbol: "NEO",
            assetType: AssetType.nativeAsset,
            decimal: 0,
            balance: Decimal(O3Cache.neoBalance()))
    }

    static func GAS() -> TransferableAsset {
        return TransferableAsset(
            assetID: NeoSwift.AssetId.gasAssetId.rawValue,
            name: "GAS",
            symbol: "GAS",
            assetType: AssetType.nativeAsset,
            decimal: 8,
            balance: Decimal(O3Cache.gasBalance()))
    }
}
