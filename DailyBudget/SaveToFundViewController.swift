//
//  SaveToFundViewController.swift
//  DailyBudget
//
//  Created by Harri Hätinen on 10/04/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class SaveToFundViewController: UIViewController {

    @IBOutlet weak var savingsTypeSelector: UISegmentedControl!
    @IBOutlet weak var savingsContainerView: UIView!
    
    var currentSavingsView : UIViewController?
    
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
        if (currentSavingsView != nil) {
            currentSavingsView?.view.removeFromSuperview()
            currentSavingsView?.removeFromParentViewController()
            currentSavingsView = nil
        }
        var id : String? = nil;
        if type == 0 {
            id = "saveToFundOneTime"
        } else if type == 1 {
            id = "saveToFundConstant"
        } else if type == 2 {
            id = "saveToFundTargetDate"
        }
        currentSavingsView = self.storyboard?.instantiateViewControllerWithIdentifier(id!)
        
        currentSavingsView!.view.translatesAutoresizingMaskIntoConstraints = false
        //currentSavingsView!.view.alpha = 0.5
        currentSavingsView!.view.userInteractionEnabled = true
        self.addChildViewController(currentSavingsView!)
        self.savingsContainerView.addSubview(currentSavingsView!.view)
        self.savingsContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|", options: [], metrics: nil, views: ["subView": currentSavingsView!.view]))
self.savingsContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: [], metrics: nil, views: ["subView": currentSavingsView!.view]))
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
