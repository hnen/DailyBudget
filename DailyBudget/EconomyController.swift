//
//  EconomyController.swift
//  DailyBudget
//
//  Created by Administrator on 18/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

struct Velocity {
    let dsum : MoneySum
    let dt : Double
    
    init?(dsum : MoneySum, dt : Double) {
        if dt == 0 {
            return nil
        }
        self.dsum = dsum
        self.dt = dt
    }
    
}

class EconomyController {

    private let economy : Economy;
    
    init(economy : Economy) {
        self.economy = economy
    }
    
    func addToBalance(sum : Double, currency : String) {
        addToBalance(sum, currency: currency, date: getTime())
    }

    func addToBalance(sum : Double, currency : String, date: Double) {
        let moneySum = MoneySum(sum: sum, currency: currency, rate: Currencies.getRate(currency));
        self.economy.timeline.events.append(AddEconomyBalanceEvent(date: date, balanceDelta: moneySum))
    }
    
    func setCurrentVelocity(vel : Velocity) {
        setCurrentVelocity(vel, date: getTime())
    }
    
    func setCurrentVelocity(vel : Velocity, date : Double) {
        self.economy.timeline.events.append(SetEconomyBalanceVelocityEvent(date: date, deltaAmount: vel.dsum, deltaTime: vel.dt))
    }
    
    func evaluateBalance(currency : String) -> MoneySum {
        return evaluateBalance(currency, date: getTime())
    }
    
    func evaluateBalance(currency : String, date : Double) -> MoneySum {
        return evaluateTimelineBalance(self.economy.timeline, tgtDate: date, tgtCurrency: currency)
    }
    
    func saveEconomy() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(economy, toFile: Economy.ArchiveURL.path!)
        assert(isSuccessfulSave)
    }
    
    static func loadEconomy() -> Economy? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Economy.ArchiveURL.path!) as? Economy
    }
    
    func evaluateTimelineBalance(timeline : EconomyTimeline, tgtDate : Double, tgtCurrency : String) -> MoneySum {
        let sortedTimeline = timeline.events.sort(cmp)
        var prevDate : Double = 0.0;
        var prevBalance : Double = 0.0;
        var prevVelocity = Velocity(dsum: MoneySum(sum: 0, currency: "EUR", rate: 1), dt: 1)!;
        for event in sortedTimeline {
            let date = event.date;
            if date > tgtDate {
                break
            } else {
                var balance = prevBalance
                var velocity = prevVelocity
                let dt = date - prevDate;
                balance = prevBalance + Currencies.exchange(velocity.dsum, to: tgtCurrency).sum * dt / velocity.dt
                if let setBalanceEvent = event as? SetEconomyBalanceEvent {
                    balance = Currencies.exchange(setBalanceEvent.newBalance, to: tgtCurrency).sum
                } else if let setVelocityEvent = event as? SetEconomyBalanceVelocityEvent {
                    velocity = Velocity(dsum: setVelocityEvent.newVelocityDeltaAmount, dt: setVelocityEvent.newVelocityDeltaTime)!
                } else if let addBalanceEvent = event as? AddEconomyBalanceEvent {
                    balance += Currencies.exchange(addBalanceEvent.balanceDelta, to: tgtCurrency).sum
                } else {
                    assert(false);
                }
                prevDate = date
                prevBalance = balance
                prevVelocity = velocity
            }
        }
    
        let currency = Currencies.getCurrency(tgtCurrency)!
        
        let dt = tgtDate - prevDate;
        return MoneySum(sum: prevBalance + Currencies.exchange(prevVelocity.dsum, to: tgtCurrency).sum * dt / prevVelocity.dt, currency: tgtCurrency, rate: currency.rate)
        
    }
    
    func getTime() -> Double {
        return CFAbsoluteTimeGetCurrent()
    }
    
    func cmp(a : EconomyTimelineEvent, b : EconomyTimelineEvent) -> Bool {
        return a.date <= b.date;
    }
    
    
}
