//
//  NEP5Token.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
struct NEP5Token: Codable, Hashable {

    var logoURL: String!
    var tokenHash: String!
    var name: String!
    var symbol: String!
    var decimal: Int!
    var totalSupply: Int!

    var hashValue: Int {
        return tokenHash.hashValue
    }

    static func == (lhs: NEP5Token, rhs: NEP5Token) -> Bool {
        return lhs.tokenHash == rhs.tokenHash
    }

    enum CodingKeys: String, CodingKey {
        case logoURL
        case tokenHash
        case name
        case symbol
        case decimal
        case totalSupply
    }

    public init(logoURL: String, tokenHash: String, name: String, symbol: String, decimal: Int, totalSupply: Int) {
        self.logoURL = logoURL
        self.tokenHash = tokenHash
        self.name = name
        self.symbol = symbol
        self.decimal = decimal
        self.totalSupply = totalSupply
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let logoURL: String = try container.decode(String.self, forKey: .logoURL)
        let tokenHash: String = try container.decode(String.self, forKey: .tokenHash)
        let name: String = try container.decode(String.self, forKey: .name)
        let symbol: String = try container.decode(String.self, forKey: .symbol)
        let decimal: Int = try container.decode(Int.self, forKey: .decimal)
        let totalSupply: Int = try container.decode(Int.self, forKey: .totalSupply)
        self.init(logoURL: logoURL, tokenHash: tokenHash, name: name, symbol: symbol, decimal: decimal, totalSupply: totalSupply)
    }
}
