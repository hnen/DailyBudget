//
//  SaveToFundViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 10/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SaveToFundViewController: UIViewController {

    @IBOutlet weak var oneTimeSavingsView: UIView!
    @IBOutlet weak var constantSavingsView: UIView!
    @IBOutlet weak var targetSavingsView: UIView!
    @IBOutlet weak var savingsTypeSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setSavingsType(0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    @IBAction func savingsTypeChanged(sender: AnyObject) {
        setSavingsType(savingsTypeSelector.selectedSegmentIndex)
    }
    
    func setSavingsType(type : Int) {
        if type == 0 {
            oneTimeSavingsView.hidden = false
            constantSavingsView.hidden = true
            targetSavingsView.hidden = true
        } else if type == 1 {
            oneTimeSavingsView.hidden = true
            constantSavingsView.hidden = false
            targetSavingsView.hidden = true
        } else if type == 2 {
            oneTimeSavingsView.hidden = true
            constantSavingsView.hidden = true
            targetSavingsView.hidden = false
        } else {
            oneTimeSavingsView.hidden = true
            constantSavingsView.hidden = true
            targetSavingsView.hidden = true
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
