//
//  FundTableView.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 09/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit


class FundTableViewDelegate : NSObject, UITableViewDataSource {

    @IBOutlet weak var mainViewController: ViewController!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let balance = mainViewController.evaluateBalance();
        return balance.accounts.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FundTableViewCell", forIndexPath: indexPath) as! FundTableViewCell;
        let balance = mainViewController.evaluateBalance();
        let row = indexPath.row
        cell.initialize(mainViewController.economyController!, account: nil)
        if row >= balance.accounts.count {
            cell.initialize(mainViewController.economyController!, account: nil);
        } else {
            cell.initialize(mainViewController.economyController!, account: balance.accounts[row].name)
        }
        return cell
    }
    
}
