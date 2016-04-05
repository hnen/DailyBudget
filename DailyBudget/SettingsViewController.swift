//
//  SettingsViewController.swift
//  DailyBudget
//
//  Created by Administrator on 31/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SettingsViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var activeCurrencyPicker: UIPickerView!
    
    var settings : SettingsController?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings = SettingsController.get()
        
        initActiveCurrencyPicker()
    }
    
    func initActiveCurrencyPicker() {
        self.activeCurrencyPicker.delegate = self
        self.activeCurrencyPicker.dataSource = self
    }
    
    func selectCurrency(currency : String) {
        self.settings!.setActiveCurrency(currency)
        
        var row : Int?
        for i in 0..<Currencies.currencies.count {
            if (Currencies.currencies[i].code == currency) {
                row = i
                break
            }
        }
        self.activeCurrencyPicker.selectRow(row!, inComponent: 0, animated: false)
    }

    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currencies.currencies[row].code
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCurrency(Currencies.currencies[row].code)
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Currencies.currencies.count
    }


    
}
