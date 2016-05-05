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
    
    var delegate : UITextFieldDelegate?;
    
    private var economyController : EconomyController?;
    var economyBalanceContainer : EconomyBalanceContainer?;
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
        self.economyBalanceContainer = EconomyBalanceContainer(economyController: self.economyController!)

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
    
    // MARK: Methods
    func updateBalanceText() {
        let currencyName = self.settings?.getActiveCurrency()
        let balance = self.economyController!.evaluateBalance(currencyName!)
        let currency = Currencies.getCurrency(currencyName!)!
        
        let balanceRounded = round(balance.total.sum * 100.0) / 100.0
        let text = NSString(format: currency.sumFormat, balanceRounded);
        balanceLabel.text = String(text);
    }
    
    func evaluateBalance() -> EconomyBalance {
        return economyController!.evaluateBalance(settings!.getActiveCurrency())
    }
 
    // MARK: Navigation

    @IBAction func unwindToMainView(sender: UIStoryboardSegue) {
        if let addFundVC = sender.sourceViewController as? AddFundViewController {
            if let newFundName = addFundVC.newFundName {
                economyController!.addFund(newFundName)
                economyController!.saveEconomy()
            }
        }
        if let spendVC = sender.sourceViewController as? SpendFromFundViewController {
            if spendVC.amountToSpend != nil {
                if (spendVC.dstAccount != nil) {
                    economyController!.spendFromFund(spendVC.dstAccount!, sum: spendVC.amountToSpend!, currency: settings!.getActiveCurrency())
                } else {
                    economyController!.spendFromFund("", sum: spendVC.amountToSpend!, currency: settings!.getActiveCurrency())
                }
                economyController!.saveEconomy()
            }
        }
        if let saveVC = sender.sourceViewController as? SaveToFundViewController {
            var dstAccount = ""
            if (saveVC.dstAccount != nil) {
                dstAccount = saveVC.dstAccount!
            }
            if saveVC.oneTimeSaving != nil {
                economyController!.transferToFund(dstAccount, sum: saveVC.oneTimeSaving!, currency: settings!.getActiveCurrency())
            }
            if saveVC.savingVelocity != nil {
                economyController!.saveToFund(dstAccount, velocity: saveVC.savingVelocity!, dt: 60*60*24, currency: settings!.getActiveCurrency(), targetSum: saveVC.savingTarget)
            }
            economyController!.saveEconomy()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let settingsVC = segue.destinationViewController as? SettingsViewController {
            settingsVC.economyController = self.economyController
        }
        
        if let nc = segue.destinationViewController as? UINavigationController {
            if let spendVC = nc.childViewControllers[0] as? SpendFromFundViewController {
                if let btn = sender as? FundTableViewButton {
                    spendVC.dstAccount = btn.dstAccount
                    print("is fundtableviewbutton: \(btn.dstAccount)")
                } else {
                    print("is not fundtableviewbutton :(")
                }
                spendVC.economyController = self.economyController
            }
            if let saveVC = nc.childViewControllers[0] as? SaveToFundViewController {
                if let btn = sender as? FundTableViewButton {
                    saveVC.dstAccount = btn.dstAccount
                }
                saveVC.economyController = self.economyController
            }
            
        }
        
        
        
    }

}

