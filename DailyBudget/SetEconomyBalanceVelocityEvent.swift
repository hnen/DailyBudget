//
//  SetEconomyBalanceVelocityEvent.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 06/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SetEconomyBalanceVelocityEvent : EconomyTimelineEvent {
    var newVelocityDeltaAmount : MoneySum;
    var newVelocityDeltaTime : Double;
    
    init(date : Double, deltaAmount : MoneySum, deltaTime : Double) {
        self.newVelocityDeltaAmount = deltaAmount
        self.newVelocityDeltaTime = deltaTime
        super.init(date: date);
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let deltaAmount = aDecoder.decodeObjectForKey(PropertyKey.newVelocityDeltaAmount) as! MoneySum
        let deltaTime = aDecoder.decodeDoubleForKey(PropertyKey.newVelocityDeltaTime)
        let date = aDecoder.decodeDoubleForKey(PropertyKey.dateKey)
        self.init(date: date, deltaAmount: deltaAmount, deltaTime: deltaTime)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.newVelocityDeltaAmount, forKey: PropertyKey.newVelocityDeltaAmount)
        aCoder.encodeDouble(self.newVelocityDeltaTime, forKey: PropertyKey.newVelocityDeltaTime)
        super.encodeWithCoder(aCoder)
    }
    
    struct PropertyKey {
        static let newVelocityDeltaAmount = "newVelocityDeltaAmount"
        static let newVelocityDeltaTime = "newVelocityDeltaTime"
    }
    
}
