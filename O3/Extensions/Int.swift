//
//  Int.swift
//  O3
//
//  Created by Andrei Terentiev on 2/5/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

extension Int {
    func tagToPriceIntervalString() -> String {
        switch self {
        case 0: return "6h"
        case 1: return "24h"
        case 2: return "1w"
        case 3: return "1m"
        case 4: return "3m"
        case 5: return "all"
        default: return ""
        }
    }
}
