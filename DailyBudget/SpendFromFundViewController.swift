//
//  SpendFromFundViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 10/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SpendFromFundViewController: UIViewController {

    @IBOutlet weak var spendFromFundLabel: UILabel!
    @IBOutlet weak var spendFromFundTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var economyController : EconomyController?
    var dstAccount : String?
    
    var amountToSpend : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let settings = SettingsController.get()
        if dstAccount != nil {
            print ("dstAccount = \(dstAccount)")
            spendFromFundLabel.text = String(NSString(format: "Spend from \"%@\" (in %@)", dstAccount!, settings.getActiveCurrency()))
        } else {
            print ("dstAccount = general")
            spendFromFundLabel.text = String(NSString(format: "Spend from \"%@\" (in %@)", "General", settings.getActiveCurrency()))
        }
        
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        amountToSpend = nil
        if (sender === saveButton) {
            amountToSpend = Double(spendFromFundTextField.text!);
        }
    }

}
