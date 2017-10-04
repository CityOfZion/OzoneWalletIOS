//
//  String.swift
//  O3
//
//  Created by Andrei Terentiev on 9/24/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

extension String {
    func intervaledDateString(_ interval: PriceInterval) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else {
            fatalError("Invalid posix formatted string")
        }
        if interval.rawValue < 60 {
            dateFormatter.dateFormat = "hh:mm"
        } else {
            dateFormatter.dateFormat = "MMM d, hh:mm"
        }
        dateFormatter.locale = tempLocale
        return dateFormatter.string(from: date)
    }

    static func formattedAmountChange(amount: Double, currency: Currency) -> String {
        let amountNumber = NSNumber(value: amount)
        let formatter = NumberFormatter()
        formatter.negativeFormat = "- #,##0.00"
        formatter.positiveFormat = "+ #,##0.00"
        formatter.minimumFractionDigits = currency == .btc ? Precision.btc : Precision.usd
        formatter.numberStyle = .decimal
        if let formattedTipAmount = formatter.string(from: amountNumber as NSNumber) {
            return formattedTipAmount
        }
        return ""
    }

    static func percentChangeString(latestPrice: PriceData, previousPrice: PriceData, with selectedInterval: PriceInterval, referenceCurrency: Currency) -> String {
        var percentChange = 0.0
        var amountChange = 0.0
        var amountChangeString = ""

        switch referenceCurrency {
        case .btc:
            amountChange = latestPrice.averageBTC - previousPrice.averageBTC
            amountChangeString = String.formattedAmountChange(amount: amountChange, currency: .btc)
            percentChange = (amountChange / previousPrice.averageBTC) * 100
        case .usd:
            amountChange = latestPrice.averageUSD - previousPrice.averageUSD
            amountChangeString = String.formattedAmountChange(amount: amountChange, currency: .usd)
            percentChange = (amountChange / previousPrice.averageUSD) * 100
        }
        let posixString = previousPrice.time
        return String(format:"%@ (%.2f%@) SINCE %@", amountChangeString, percentChange, "%", posixString.intervaledDateString(selectedInterval))
    }

    static func percentChangeStringShort(latestPrice: PriceData, previousPrice: PriceData, referenceCurrency: Currency) -> String {
        var percentChange = 0.0
        var amountChange = 0.0

        switch referenceCurrency {
        case .btc:
            amountChange = latestPrice.averageBTC - previousPrice.averageBTC
            percentChange = (amountChange / previousPrice.averageBTC) * 100
        case .usd:
            amountChange = latestPrice.averageUSD - previousPrice.averageUSD
            percentChange = (amountChange / previousPrice.averageUSD) * 100
        }
        return String(format:"%.2f%@", percentChange, "%")
    }

    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func validNEOAddress(completion: @escaping(Bool) -> Void) {
        Neo.client.validateAddress(self) { (result) in
            switch result {
            case .failure:
                completion(false)
            case .success(let valid):
                completion(valid)
            }
        }
    }

}
