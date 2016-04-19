//
//  SaveToFundTargetDateViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 17/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SaveToFundTargetDateViewController: UIViewController {

    @IBOutlet weak var targetSumTextField: UITextField!
    @IBOutlet weak var targetDatePicker: UIDatePicker!
    @IBOutlet weak var statsLabel: UILabel!
    
    var velocity : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
