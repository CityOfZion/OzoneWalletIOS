//
//  Double.swift
//  O3
//
//  Created by Andrei Terentiev on 9/23/17.
//  Copyright © 2017 drei. All rights reserved.
//
import Foundation

extension Double {
    func string(_ precision: Int, removeTrailing: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = precision
        formatter.numberStyle = .decimal
        var stringWithTrailing = formatter.string(from: self as NSNumber) ?? "\(self)"
        if !removeTrailing {
            return stringWithTrailing
        }
        var truncated = stringWithTrailing
        for x in (0...stringWithTrailing.characters.count-1).reversed() {
            let lastChar = stringWithTrailing[stringWithTrailing.index(stringWithTrailing.startIndex, offsetBy: x)]
            if lastChar == "0" || lastChar == "." {
                truncated = String(truncated.dropLast())
            } else {
                break
            }
        }

        if truncated.characters.count == 0 {
            return "0"
        } else {
            return truncated
        }

    }

    func stringWithSign(_ precision: Int) -> String {
        let formatter = NumberFormatter()
        formatter.negativeFormat = "- #,##0.00"
        formatter.positiveFormat = "+ #,##0.00"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? "\(self)"
    }
}
