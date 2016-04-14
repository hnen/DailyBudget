//
//  AddFundEvent.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 09/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class AddFundEvent : EconomyTimelineEvent {

    let newFundName : String
    
    init (date: Double, newFundName : String) {
        self.newFundName = newFundName
        super.init(date: date)
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let newFundName = aDecoder.decodeObjectForKey(PropertyKey.newFundNameKey) as! String
        let date = aDecoder.decodeDoubleForKey(PropertyKey.dateKey)
        self.init(date: date, newFundName: newFundName)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.newFundName, forKey: PropertyKey.newFundNameKey)
        super.encodeWithCoder(aCoder)
    }
    
    struct PropertyKey {
        static let newFundNameKey = "newFundName"
    }
    
    
}
