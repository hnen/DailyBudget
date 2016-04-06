//
//  ViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 12/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var newExpenseTextField: UITextField!
    @IBOutlet weak var newExpenseLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var newExpenseButton: UIButton!
    @IBOutlet weak var setVelocityTextField: UITextField!
    
    var delegate : UITextFieldDelegate?;
    
    var economyController : EconomyController?;
    var updateBalanceTimer : NSTimer?;
    
    var settings : SettingsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad");
        
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate = AddNewExpenseTextFieldDelegate(balanceLabel: self.newExpenseLabel)
        newExpenseTextField.delegate = self.delegate
        
        let economyData = EconomyController.loadEconomy()
        if (economyData == nil) {
            self.economyController = EconomyController(economy: Economy())
        } else {
            self.economyController = EconomyController(economy: economyData!)
        }
        

        self.settings = SettingsController.get()
        
        self.updateBalanceTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateBalanceText", userInfo: nil, repeats: true)
        
        updateBalanceText()
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: Actions
    
    @IBAction func addNewExpense(sender: AnyObject) {
        if let sumInt = Double(newExpenseTextField.text!) {
            self.economyController!.addToBalance(-sumInt, currency: self.settings!.getActiveCurrency())
            updateBalanceText()
            economyController!.saveEconomy()
        }
    }
    @IBAction func setCurrentVelocityPressed(sender: AnyObject) {
        if let newVelocityInt = Double(setVelocityTextField.text!) {
            let currency = Currencies.getCurrency(self.settings!.getActiveCurrency())!;
            self.economyController!.setCurrentVelocity(Velocity(dsum: MoneySum(sum: newVelocityInt, currency: currency.code, rate: currency.rate), dt: 60*60*24)!)
            updateBalanceText()
            economyController!.saveEconomy()
        }
    }
    
    // MARK: Methods
    
    func updateBalanceText() {
        let currencyName = self.settings?.getActiveCurrency()
        let balance = self.economyController!.evaluateBalance(currencyName!)
        let currency = Currencies.getCurrency(currencyName!)!
        
        let balanceRounded = round(balance.sum * 10.0) / 10.0
        let text = NSString(format: currency.sumFormat, balanceRounded);
        balanceLabel.text = String(text);
    }
    
    
    @IBAction func unwindToMainView(sender: UIStoryboardSegue) {
    }

    
    
    

}

