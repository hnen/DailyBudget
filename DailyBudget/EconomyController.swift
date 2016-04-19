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
    
    func add(avel : Velocity) -> Velocity {
        return Velocity(dsum: self.dsum.add(avel.dsum.mul(self.dt / avel.dt)), dt: self.dt)!
    }
    func sub(avel : Velocity) -> Velocity {
        return Velocity(dsum: self.dsum.sub(avel.dsum.mul(self.dt / avel.dt)), dt: self.dt)!
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

    func addFund(name : String) {
        addFund(name, date: getTime())
    }
    
    func addFund(name : String, date: Double) {
        self.economy.timeline.events.append(AddFundEvent(date: date, newFundName: name))
    }
    
    func spendFromFund(fundName : String, sum : Double, currency : String) {
        let moneySum = MoneySum(sum: sum, currency: currency, rate: Currencies.getRate(currency));
        self.economy.timeline.events.append(SpendEvent(date: getTime(), moneyAmount: moneySum, fundName: fundName))
    }
    
    func transferToFund(fundName : String, sum : Double, currency : String) {
        let moneySum = MoneySum(sum: sum, currency: currency, rate: Currencies.getRate(currency));
        self.economy.timeline.events.append(TransferToFundEvent(date: getTime(), moneyAmount: moneySum, fundName: fundName))
    }
    
    func saveToFund(fundName : String, velocity : Double, dt : Double, currency :  String, targetSum : Double?) {
        let vel = Velocity(dsum: MoneySum(sum: velocity, currency: currency, rate: Currencies.getRate(currency)), dt: dt)!
        self.economy.timeline.events.append(SetFundSavingEvent(date: getTime(), velocity: vel, fundName: fundName, targetAmount: targetSum))
    }
    
    func setCurrentVelocity(vel : Velocity) {
        setCurrentVelocity(vel, date: getTime())
    }
    
    func setCurrentVelocity(vel : Velocity, date : Double) {
        self.economy.timeline.events.append(SetEconomyBalanceVelocityEvent(date: date, deltaAmount: vel.dsum, deltaTime: vel.dt))
    }
    
    func evaluateBalance(currency : String) -> EconomyBalance {
        return evaluateBalance(currency, date: getTime())
    }
    
    func evaluateBalance(currency : String, date : Double) -> EconomyBalance {
        return evaluateTimelineBalance(self.economy.timeline, tgtDate: date, tgtCurrency: currency)
    }
    
    func saveEconomy() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(economy, toFile: Economy.ArchiveURL.path!)
        assert(isSuccessfulSave)
    }
    
    static func loadEconomy() -> Economy? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Economy.ArchiveURL.path!) as? Economy
    }
    
    func evaluateTimelineBalance(timeline : EconomyTimeline, tgtDate : Double, tgtCurrency : String) -> EconomyBalance {
        let sortedTimeline = timeline.events.sort(cmp)
        var prevDate : Double = 0.0;
        var prevBalance : Double = 0.0;
        var prevVelocity = Velocity(dsum: MoneySum(sum: 0, currency: "EUR", rate: 1), dt: 1)!;
        let ret = EconomyBalance(currency: Currencies.getCurrency(tgtCurrency)!)
        for event in sortedTimeline {
            let date = event.date;
            if date > tgtDate {
                break
            } else {
                var balance = prevBalance
                var velocity = prevVelocity
                let dt = date - prevDate;
                balance = prevBalance + Currencies.exchange(velocity.dsum, to: tgtCurrency).sum * dt / velocity.dt
                for acc in ret.accounts {
                    acc.balance = acc.balance.add(acc.velocity.dsum.mul(dt / acc.velocity.dt))
                    if acc.savingTarget != nil {
                        if acc.balance.isGreaterThanEqualTo(acc.savingTarget!) {
                            acc.balance = acc.balance.clamp(acc.savingTarget!)
                            acc.velocity = Velocity(dsum: MoneySum(sum: 0, currency: acc.balance.currency, rate: acc.balance.rate), dt: 1)!
                        }
                    }
                }
                if let setBalanceEvent = event as? SetEconomyBalanceEvent {
                    balance = Currencies.exchange(setBalanceEvent.newBalance, to: tgtCurrency).sum
                } else if let setVelocityEvent = event as? SetEconomyBalanceVelocityEvent {
                    velocity = Velocity(dsum: setVelocityEvent.newVelocityDeltaAmount, dt: setVelocityEvent.newVelocityDeltaTime)!
                } else if let addBalanceEvent = event as? AddEconomyBalanceEvent {
                    balance += Currencies.exchange(addBalanceEvent.balanceDelta, to: tgtCurrency).sum
                } else if let addFundEvent = event as? AddFundEvent {
                    ret.accounts.append(EconomyBalanceAccount(name: addFundEvent.newFundName, currency: Currencies.getCurrency(tgtCurrency)!))
                } else if let spendFromFundEvent = event as? SpendEvent {
                    let acc = ret.getAccount(spendFromFundEvent.fundName);
                    if (acc != nil) {
                        acc!.balance = acc!.balance.sub(spendFromFundEvent.moneyAmount)
                    }
                    balance -= Currencies.exchange(spendFromFundEvent.moneyAmount, to: tgtCurrency).sum
                } else if let transferToFundEvent = event as? TransferToFundEvent {
                    let acc = ret.getAccount(transferToFundEvent.fundName);
                    if (acc != nil) {
                        acc!.balance = acc!.balance.add(transferToFundEvent.moneyAmount)
                    }
                } else if let ev = event as? SetFundSavingEvent {
                    let acc = ret.getAccount(ev.fundName);
                    if (acc != nil) {
                        acc!.velocity = Velocity(dsum: ev.velocity_dsum, dt: ev.velocity_dt)!
                        if (ev.targetAmount != nil) {
                            acc!.savingTarget = MoneySum(sum: ev.targetAmount!, currency: ev.velocity_dsum.currency, rate: ev.velocity_dsum.rate)
                        }
                    }
                } else {
                    assert(false);
                }
                prevDate = date
                prevBalance = balance
                prevVelocity = velocity
            }
        }
    
        let dt = tgtDate - prevDate;
        
        let finalBalance = prevBalance + Currencies.exchange(prevVelocity.dsum, to: tgtCurrency).sum * dt / prevVelocity.dt
        ret.total = MoneySum(sum: finalBalance, currency: tgtCurrency, rate: Currencies.getCurrency(tgtCurrency)!.rate)
        ret.velocity = prevVelocity
        for acc in ret.accounts {
            acc.balance = acc.balance.add(acc.velocity.dsum.mul(dt / acc.velocity.dt))
            if acc.savingTarget != nil {
                if acc.balance.isGreaterThanEqualTo(acc.savingTarget!) {
                    acc.balance = acc.balance.clamp(acc.savingTarget!)
                    acc.velocity = Velocity(dsum: MoneySum(sum: 0, currency: acc.balance.currency, rate: acc.balance.rate), dt: 1)!
                }
            }
        }
        
        return ret
        
    }
    
    func getTime() -> Double {
        return CFAbsoluteTimeGetCurrent()
    }
    
    func cmp(a : EconomyTimelineEvent, b : EconomyTimelineEvent) -> Bool {
        return a.date <= b.date;
    }
    
    
}
