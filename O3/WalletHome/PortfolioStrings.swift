//
//  PortfolioStrings.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

struct PortfolioStrings {
    static let portfolioHeaderO3Wallet = NSLocalizedString("PORTFOLIO_O3_Wallet_Header", comment: "A header title on the portfolio screen, shows the displayed funds are located in the O3Wallet")
    static let portfolioHeaderCombinedHeader = NSLocalizedString("PORTFOLIO_Combined_Header", comment: "A header title on the portfolio screen, show the displayed funds are a combination of those store in O3 wallet and cold storage")
    static let portfolioHeaderColdStorageHeader = NSLocalizedString("PORTFOLIO_Cold_Storage_Header", comment: "A header title on the portfolio screen, show the displayed funds are inside cold storage")

    static let sixHourInterval = NSLocalizedString("PORTFOLIO_Interval_Button_6h", comment: "Interval Button on portfolio page, interval specifies SIX HOURS")
    static let oneDayInterval = NSLocalizedString("PORTFOLIO_Interval_Button_24h", comment: "Interval Button on portfolio page, interval specifies 24 HOURS")
    static let oneWeekInterval = NSLocalizedString("PORTFOLIO_Interval_Button_1W", comment: "Interval Button on portfolio page, interval specifies 1 Week")
    static let oneMonthInterval = NSLocalizedString("PORTFOLIO_Interval_Button_1M", comment: "Interval Button on portfolio page, interval specifies 1 Month")
    static let threeMonthInterval = NSLocalizedString("PORTFOLIO_Interval_Button_3M", comment: "Interval Button on portfolio page, interval specifies 3 Months")
    static let allInterval = NSLocalizedString("PORTFOLIO_Interval_Button_ALL", comment: "Interval Button on portfolio page, interval specifies ALL of Time")

    static let portfolio = NSLocalizedString("PORTFOLIO_Portfolio_Title", comment: "Title of the portfolio page")
}
