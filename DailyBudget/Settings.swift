//
//  Settings.swift
//  DailyBudget
//
//  Created by Administrator on 31/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import Foundation

class Settings {
    var activeCurrency : String
    
    init (activeCurrency : String) {
        self.activeCurrency = activeCurrency
    }
    
}

class SettingsController {
    
    static var instance : SettingsController?
    
    let settings : Settings
    
    init (settings : Settings) {
        self.settings = settings
    }
    
    static func get() -> SettingsController {
        if (instance == nil) {
            instance = SettingsController(settings: Settings(activeCurrency: "EUR"))
        }
        return instance!
    }
    
    func setActiveCurrency(newCurrency : String) {
        settings.activeCurrency = newCurrency
    }
    
    func getActiveCurrency() -> String! {
        return settings.activeCurrency
    }
    
}
