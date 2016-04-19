//
//  SpendEvent.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 14/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SetFundSavingEvent : EconomyTimelineEvent {
    let fundName : String
    let velocity_dsum : MoneySum
    let velocity_dt : Double
    
    let targetAmount : Double?
    
    init(date : Double, velocity : Velocity, fundName : String, targetAmount : Double?) {
        self.velocity_dsum = velocity.dsum
        self.velocity_dt = velocity.dt
        self.fundName = fundName;
        self.targetAmount = targetAmount
        super.init(date: date)
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let velocity_dsum = aDecoder.decodeObjectForKey(PropertyKey.velocity_dsum) as! MoneySum
        let velocity_dt = aDecoder.decodeObjectForKey(PropertyKey.velocity_dt) as! Double
        let targetAmount = aDecoder.decodeObjectForKey(PropertyKey.targetAmount) as? Double
        let fundName = aDecoder.decodeObjectForKey(PropertyKey.fundName) as! String
        let date = aDecoder.decodeDoubleForKey(PropertyKey.dateKey)
        self.init(date: date, velocity : Velocity(dsum: velocity_dsum, dt: velocity_dt)!, fundName: fundName, targetAmount: targetAmount)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.velocity_dsum, forKey: PropertyKey.velocity_dsum)
        aCoder.encodeObject(self.velocity_dt, forKey: PropertyKey.velocity_dt)
        aCoder.encodeObject(self.targetAmount, forKey: PropertyKey.targetAmount)
        aCoder.encodeObject(self.fundName, forKey: PropertyKey.fundName)
        super.encodeWithCoder(aCoder)
    }
    
    struct PropertyKey {
        static let velocity_dsum = "velocity_dsum"
        static let velocity_dt = "velocity_dt"
        static let fundName = "fundName"
        static let targetAmount = "targetAmount"
    }
    
    
}

