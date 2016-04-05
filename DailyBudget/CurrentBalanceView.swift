//
//  CurrentBalanceView.swift
//  DailyBudget
//
//  Created by Administrator on 28/03/16.
//  Copyright © 2016 Harri Hätinen. All rights reserved.
//

import UIKit

class CurrentBalanceView : UIView {

    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
        label.text = "blaa"
        self.addSubview(label)
    }
    
}
