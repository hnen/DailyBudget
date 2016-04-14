//
//  SetEconomyBalanceEvent.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 06/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SetEconomyBalanceEvent : EconomyTimelineEvent {
    let newBalance : MoneySum;
    
    init(date : Double, balance : MoneySum) {
        self.newBalance = balance;
        super.init(date: date)
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let newBalance = aDecoder.decodeObjectForKey(PropertyKey.newBalanceKey) as! MoneySum
        let date = aDecoder.decodeDoubleForKey(PropertyKey.dateKey)
        self.init(date: date, balance: newBalance)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.newBalance, forKey: PropertyKey.newBalanceKey)
        super.encodeWithCoder(aCoder)
    }
    
    struct PropertyKey {
        static let newBalanceKey = "newBalance"
    }
    
    
}

