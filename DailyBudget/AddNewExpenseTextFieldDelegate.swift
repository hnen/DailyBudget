//
//  AddNewExpenseTextFieldDelegate.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 12/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import Foundation
import UIKit

class AddNewExpenseTextFieldDelegate : NSObject, UITextFieldDelegate {

    let sumLabel : UILabel;
    
    init(balanceLabel : UILabel) {
        self.sumLabel = balanceLabel;
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        sumLabel.text = textField.text;
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        sumLabel.text = textField.text;
    }
    

}
