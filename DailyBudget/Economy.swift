//
//  Economy.swift
//  DailyBudget
//
//  Created by Administrator on 18/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class Economy : NSObject, NSCoding {

    let timeline : EconomyTimeline
//    var looseCashAccount : Account
//    var savingsAccounts : [Account]
    
    override init () {
        self.timeline = EconomyTimeline();
        super.init()
    }
    
    init (timeline : EconomyTimeline) {
        self.timeline = timeline
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let timeline = aDecoder.decodeObjectForKey(PropertyKey.timelineKey) as! EconomyTimeline
        self.init(timeline: timeline)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(timeline, forKey: PropertyKey.timelineKey)
    }
    
    struct PropertyKey {
        static let timelineKey = "timeline"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("economy")
    
    
}

class EconomyTimeline : NSObject, NSCoding {
    var events : [EconomyTimelineEvent]
    
    override init () {
        self.events = [EconomyTimelineEvent]()
        super.init()
    }
    
    init (events : [EconomyTimelineEvent] ) {
        self.events = events
    }
    
    func addEvent(event : EconomyTimelineEvent) {
        self.events.append(event);
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let events = aDecoder.decodeObjectForKey(PropertyKey.eventsKey) as! [EconomyTimelineEvent]
        self.init(events: events)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.events, forKey: PropertyKey.eventsKey)
    }
    
    struct PropertyKey {
        static let eventsKey = "events"
    }

}

class MoneySum : NSObject, NSCoding {
    let sum : Double
    let currency : String
    let rate : Double
    
    init (sum : Double, currency : String, rate : Double) {
        self.sum = sum;
        self.currency = currency
        self.rate = rate
    }
    
    required convenience init(coder aDecoder : NSCoder) {
        let sum = aDecoder.decodeDoubleForKey(PropertyKey.sumKey)
        let currency = aDecoder.decodeObjectForKey(PropertyKey.currencyKey) as! String
        let rate = aDecoder.decodeDoubleForKey(PropertyKey.rateKey)
        self.init(sum: sum, currency: currency, rate: rate)
    }
    
    func add(money : MoneySum) -> MoneySum {
        return MoneySum(sum: self.sum + money.sum * money.rate / self.rate, currency: self.currency, rate: self.rate)
    }
    func sub(money : MoneySum) -> MoneySum {
        return MoneySum(sum: self.sum - money.sum * money.rate / self.rate, currency: self.currency, rate: self.rate)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.sum, forKey: PropertyKey.sumKey)
        aCoder.encodeObject(self.currency, forKey: PropertyKey.currencyKey)
        aCoder.encodeDouble(self.rate, forKey: PropertyKey.rateKey)
    }
    
    struct PropertyKey {
        static let sumKey = "sum"
        static let rateKey = "rate"
        static let currencyKey = "currency"
    }
    
    
}
