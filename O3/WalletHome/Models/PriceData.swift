//
//  PriceData.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/17/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

public struct PriceData: Codable {
    var average: Double
    var averageBTC: Double
    var time: String

    enum CodingKeys: String, CodingKey {
        case average
        case averageBTC
        case time
    }

    public init(average: Double, averageBTC: Double, time: String) {
        self.average = average
        self.averageBTC = averageBTC
        self.time = time
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let average: Double = try container.decode(Double.self, forKey: .average)
        let averageBTC: Double = try container.decode(Double.self, forKey: .averageBTC)
        let time: String = try container.decode(String.self, forKey: .time)
        self.init(average: average, averageBTC: averageBTC, time: time)
    }
}

extension PriceData {
    func averageFiatMoney() -> Money {
        return Fiat(amount: Float(self.average))
    }
}

extension History {
    func dataSortedAscending() -> [PriceData] {
        return self.data.reversed()
    }
}

public struct History: Codable {

    var symbol: String
    var data: [PriceData]

    enum CodingKeys: String, CodingKey {
        case symbol
        case data
    }

    public init(symbol: String, data: [PriceData]) {
        self.symbol = symbol
        self.data = data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let symbol: String = try container.decode(String.self, forKey: .symbol)
        let data: [PriceData] = try container.decode([PriceData].self, forKey: .data)
        self.init(symbol: symbol, data: data)
    }
}

public struct PortfolioValue: Codable {

    var price: [String: PriceData]
    var firstPrice: [String: PriceData]
    var data: [PriceData]

    enum CodingKeys: String, CodingKey {
        case price
        case data
        case firstPrice
    }

    public init(data: [PriceData], price: [String: PriceData], firstPrice: [String: PriceData]) {
        self.data = data
        self.price = price
        self.firstPrice = firstPrice
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let price: [String: PriceData] = try container.decode([String: PriceData].self, forKey: .price)
        let firstPrice: [String: PriceData] = try container.decode([String: PriceData].self, forKey: .firstPrice)
        let data: [PriceData] = try container.decode([PriceData].self, forKey: .data)
        self.init(data: data, price: price, firstPrice: firstPrice)
    }
}
