//
//  EconomyTimelineEvent.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 06/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class EconomyTimelineEvent : NSObject, NSCoding {
    let date : Double;
    
    init(date : Double) {
        self.date = date;
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let date = aDecoder.decodeDoubleForKey(PropertyKey.dateKey)
        self.init(date: date)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.date, forKey: PropertyKey.dateKey)
    }
    
    struct PropertyKey {
        static let dateKey = "date"
    }
    
    
}

