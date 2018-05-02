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
        formatter.minimumFractionDigits = 0 //make this minimum to zero so it's properly remove the trailing zero
        formatter.maximumFractionDigits = precision
        formatter.numberStyle = .decimal
        let stringWithTrailing = formatter.string(from: self as NSNumber) ?? "\(self)"
        return stringWithTrailing
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
