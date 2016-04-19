//
//  EconomyBalance.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 06/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class EconomyBalance {
    
    var total : MoneySum
    var velocity : Velocity
    var accounts : [EconomyBalanceAccount]
    
    init(currency : Currency) {
        self.total = MoneySum(sum: 0.0, currency: currency.code, rate: currency.rate)
        self.velocity = Velocity(dsum: MoneySum(sum: 0.0, currency: currency.code, rate: currency.rate), dt: 1.0)!
        self.accounts = [EconomyBalanceAccount]()
    }
    
    func getAccount(name : String) -> EconomyBalanceAccount? {
        for acc in accounts {
            if acc.name == name {
                return acc
            }
        }
        return nil
    }
    
}

class EconomyBalanceAccount {
    
    let name : String
    var balance : MoneySum
    var velocity : Velocity
    var savingTarget : MoneySum?
    
    init(name : String, currency : Currency) {
        self.name = name
        self.balance = MoneySum(sum: 0.0, currency: currency.code, rate: currency.rate)
        self.velocity = Velocity(dsum: MoneySum(sum: 0.0, currency: currency.code, rate: currency.rate), dt: 1)!
        self.savingTarget = nil
    }

    init(name : String, currency : Currency, velocity : Velocity) {
        self.name = name
        self.balance = MoneySum(sum: 0.0, currency: currency.code, rate: currency.rate)
        self.velocity = velocity
        self.savingTarget = nil
    }
    
}





