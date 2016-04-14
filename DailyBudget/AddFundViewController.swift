//
//  AddFundViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 07/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class AddFundViewController : UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var newFundNameTextField: UITextField!
    
    var newFundName : String?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        newFundName = nil
        
        if saveButton === sender {
            newFundName = newFundNameTextField.text
        }
    }
    
}