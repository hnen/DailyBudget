//
//  AddEconomyBalanceEvent.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 06/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class AddEconomyBalanceEvent : EconomyTimelineEvent {
    let balanceDelta : MoneySum
    
    init(date : Double, balanceDelta : MoneySum) {
        self.balanceDelta = balanceDelta;
        super.init(date: date)
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let balanceDelta = aDecoder.decodeObjectForKey(PropertyKey.balanceDelta) as! MoneySum
        let date = aDecoder.decodeDoubleForKey(PropertyKey.dateKey)
        self.init(date: date, balanceDelta: balanceDelta)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.balanceDelta, forKey: PropertyKey.balanceDelta)
        super.encodeWithCoder(aCoder)
    }
    
    struct PropertyKey {
        static let balanceDelta = "balanceDelta"
    }
    
    
}

