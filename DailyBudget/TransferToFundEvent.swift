//
//  SpendEvent.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 14/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class TransferToFundEvent : EconomyTimelineEvent {
    let moneyAmount : MoneySum
    let fundName : String
    
    init(date : Double, moneyAmount : MoneySum, fundName : String) {
        self.moneyAmount = moneyAmount;
        self.fundName = fundName;
        super.init(date: date)
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let moneyAmount = aDecoder.decodeObjectForKey(PropertyKey.moneyAmount) as! MoneySum
        let fundName = aDecoder.decodeObjectForKey(PropertyKey.fundName) as! String
        let date = aDecoder.decodeDoubleForKey(PropertyKey.dateKey)
        self.init(date: date, moneyAmount: moneyAmount, fundName: fundName)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.moneyAmount, forKey: PropertyKey.moneyAmount)
        aCoder.encodeObject(self.fundName, forKey: PropertyKey.fundName)
        super.encodeWithCoder(aCoder)
    }
    
    struct PropertyKey {
        static let moneyAmount = "moneyAmount"
        static let fundName = "fundName"
    }
    
    
}

