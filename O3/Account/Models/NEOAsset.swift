//
//  NEOAsset.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/23/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

enum AssetType: Int {
    case NativeAsset = 0
    case NEP5Token
}

struct TransferableAsset {
    var assetID: String!
    var name: String!
    var symbol: String!
    var assetType: AssetType! = AssetType.NativeAsset //default to this
    var decimal: Int!
    var balance: Decimal! = 0.0
}
