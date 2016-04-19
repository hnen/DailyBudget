//
//  Currency.swift
//  DailyBudget
//
//  Created by Administrator on 21/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit


class Currency {
    
    let code : String
    let sumFormat : String
    let rate : Double
    
    init (code : String, format : String, rate : Double) {
        self.code = code
        self.sumFormat = format
        self.rate = rate
    }
    
}

class Currencies {
    
    static let currencies = [
        Currency(code: "EUR", format: "%.2f€", rate: 1.0),
        Currency(code: "USD", format: "$%.2f", rate: 0.89),
        Currency(code: "MXN", format: "$%.2f", rate: 0.051)
    ]
    
    static func getCurrency(code : String) -> Currency? {
        for curr in currencies {
            if curr.code == code {
                return curr;
            }
        }
        return nil
    }
    
    
    static func exchange(from : MoneySum, to : String) -> MoneySum {
        let currTo = getCurrency(to)!
        return MoneySum(sum: from.sum * from.rate / currTo.rate, currency: to, rate: currTo.rate)
    }
    
    static func exchange(from : MoneySum, to : String, rate : Double) -> MoneySum {
        return MoneySum(sum: from.sum * from.rate / rate, currency: to, rate: rate)
    }
    
    static func format(sum : MoneySum) -> String {
        let curr = Currencies.getCurrency(sum.currency)
        return String(NSString(format: curr!.sumFormat, sum.sum))
    }
    
    static func getRate(currencyCode : String) -> Double {
        return getCurrency(currencyCode)!.rate
        
    }
    
}


