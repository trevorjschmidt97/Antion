//
//  Int+String.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

extension Int {
    func formattedAmount() -> String {
        let balanceString = String(self)
        if balanceString.count == 0 {
            return "0.00"
        } else if balanceString.count == 1 {
            return "0.0" + balanceString
        } else if balanceString.count == 2 {
            return "0." + balanceString
        } else {
            return balanceString.prefix(balanceString.count-2) + "." + balanceString.suffix(2)
        }
    }
}
