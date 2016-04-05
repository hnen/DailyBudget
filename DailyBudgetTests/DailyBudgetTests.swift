//
//  DailyBudgetTests.swift
//  DailyBudgetTests
//
//  Created by Harri Hätinen on 12/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit
import XCTest
@testable import DailyBudget

class DailyBudgetTests: XCTestCase {
    
    // MARK: Daily Budget tests
    
    func testEconomyTimelineEvaluation() {
        let testEconomy = Economy()
        let economyController = EconomyController(economy: testEconomy)
        
        let sum0 = economyController.evaluateBalance("EUR", date: 0)
        XCTAssert(sum0.currency == "EUR")
        XCTAssert(sum0.sum == 0.0)
        
        economyController.addToBalance(100.0, currency: "EUR", date: 1.0)
        
        let sum1 = economyController.evaluateBalance("EUR", date: 1.0)
        XCTAssert(sum1.sum == 100.0)

        economyController.addToBalance(-100.0, currency: "EUR", date: 2.0)
        let sum2 = economyController.evaluateBalance("EUR", date: 1.5)
        XCTAssert(sum2.sum == 100.0)
        let sum3 = economyController.evaluateBalance("EUR", date: 2.0)
        XCTAssert(sum3.sum == 0.0)
        
        economyController.setCurrentVelocity(Velocity(dsum: MoneySum(sum: 1.0, currency: "EUR", rate: 1.0), dt:1.0)!, date: 0.0)
        let sum4 = economyController.evaluateBalance("EUR", date: 0.5)
        XCTAssert(sum4.sum == 0.5)
        let sum5 = economyController.evaluateBalance("EUR", date: 1.0)
        
        
        XCTAssert(sum5.sum == 101.0, "sum5 was \(sum5.sum), 101.0 expected")
        let sum6 = economyController.evaluateBalance("EUR", date: 2.0)
        XCTAssert(sum6.sum == 2.0, "sum6 was \(sum6.sum), 2.0 expected")
        
        
    }
    
}
