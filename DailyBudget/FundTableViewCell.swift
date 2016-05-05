//
//  FundTableViewCell.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 09/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class FundTableViewCell: UITableViewCell {

    @IBOutlet weak var fundTitleLabel: UILabel!
    @IBOutlet weak var fundBalanceLabel: UILabel!
    @IBOutlet weak var spendButton: FundTableViewButton!
    @IBOutlet weak var saveButton: FundTableViewButton!
    @IBOutlet weak var velocityLabel: UILabel!
    
    var updateBalanceTimer : NSTimer?;
    var economyBalanceContainer : EconomyBalanceContainer?
    var accountName : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initialize(economyBalanceContainer : EconomyBalanceContainer, account : String?) {
        if (account == nil) {
            fundTitleLabel.text = "General"
        } else {
            fundTitleLabel.text = account!
        }
        self.accountName = account
        
        spendButton.dstAccount = account
        saveButton.dstAccount = account
        
        self.economyBalanceContainer = economyBalanceContainer;
        self.updateBalanceTimer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: "updateBalanceText", userInfo: nil, repeats: true)
        updateBalanceText();
    }
    
    func updateBalanceText() {
        let settings = SettingsController.get()
        let currencyName = settings.getActiveCurrency()
        let balance = self.economyBalanceContainer!.getEconomyBalance()
        let currency = Currencies.getCurrency(currencyName!)!
        
        let balanceAmount = Currencies.exchange(getBalanceAmount(balance, accountName: accountName), to: currency.code)
        
        let balanceRounded = round(balanceAmount.sum * 100.0) / 100.0
        let text = NSString(format: currency.sumFormat, balanceRounded);
        fundBalanceLabel.text = String(text);
        
        var dailySum : MoneySum
        if self.accountName != nil {
            let acc = balance.getAccount(self.accountName!)
            let vel = acc!.velocity
            dailySum = vel.dsum.mul(24*60*60 / vel.dt)
        } else {
            var vel = balance.velocity
            for acc in balance.accounts {
                vel = vel.sub(acc.velocity)
            }
            dailySum = vel.dsum.mul(24*60*60 / vel.dt)
        }
        let dailySumFinal = Currencies.exchange(dailySum, to: currency.code)
        velocityLabel.text = String(NSString(format: "%@ / d", Currencies.format(dailySumFinal)))
    }
    
    func getBalanceAmount(balance : EconomyBalance, accountName : String?) -> MoneySum
    {
        if accountName == nil {
            var sum = balance.total
            for acc in balance.accounts {
                sum = sum.sub(acc.balance)
            }
            return sum
        } else {
            let account = getAccount(balance, accountName: accountName)!
            return account.balance
        }
    }
    
    func getAccount(balance : EconomyBalance, accountName : String?) -> EconomyBalanceAccount? {
        for acc in balance.accounts {
            if acc.name == accountName! {
                return acc
            }
        }
        return nil
    }
    
    
    @IBAction func spendPressed(sender: AnyObject) {
    }
    
    @IBAction func savePressed(sender: AnyObject) {
    }
    
}
