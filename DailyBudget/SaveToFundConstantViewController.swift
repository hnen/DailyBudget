//
//  SaveToFundConstantViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 17/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SaveToFundConstantViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var savingVelocityTextField: UITextField!
    @IBOutlet weak var targetSumTextField: UITextField!
    @IBOutlet weak var statsLabel: UILabel!
    
    var economyController : EconomyController?
    var accName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateStats()
        targetSumTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func setup(economyController : EconomyController, accName : String) {
        self.economyController = economyController
        self.accName = accName
        updateStats()
    }

    func textFieldDidEndEditing(textField: UITextField) {
        updateStats()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateStats() {
        if self.economyController == nil {
            self.statsLabel.text = ""
            return;
        }
        let settings = SettingsController.get()
        let balance = economyController?.evaluateBalance(settings.getActiveCurrency()!)
        
        var vel = balance!.velocity
        for acc in balance!.accounts {
            if acc.name != self.accName {
                let avel = acc.velocity
                vel = vel.sub(avel)
            }
        }
        
        let sumd = vel.dsum.mul(60*60*24 / vel.dt)
        let statText = String(NSString(format: "Free velocity: %@ / d", Currencies.format(sumd)))
        if (self.statsLabel != nil) {
            self.statsLabel.text = statText
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
