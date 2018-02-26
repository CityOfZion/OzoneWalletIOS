//
//  Decimal.swift
//  O3
//
//  Created by Andrei Terentiev on 2/23/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

extension Decimal {
    func formattedBalance(decimals: Int) -> String {
        let balanceDecimal = self / pow(10, decimals)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimals
        formatter.numberStyle = .decimal
        return formatter.string(for: balanceDecimal)!
    }
}
