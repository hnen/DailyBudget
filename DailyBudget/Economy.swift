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
