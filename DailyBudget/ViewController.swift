//
//  ViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 12/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var newExpenseTextField: UITextField!
    @IBOutlet weak var newExpenseLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var delegate : UITextFieldDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad");
        
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate = AddNewExpenseTextFieldDelegate(balanceLabel: self.newExpenseLabel)
        newExpenseTextField.delegate = self.delegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        balanceLabel.text = "GRR";
        print("perskeles");
    }

    
    // MARK: Actions
    
    @IBAction func addNewExpense(sender: AnyObject) {
    }

}

