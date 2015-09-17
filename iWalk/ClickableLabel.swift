//
//  ClickableLabel.swift
//  iWalk
//
//  Created by Andrea Piscitello on 17/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class ClickableLabel:PRLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override var enabled: Bool {
        willSet(newValue) {
            
        }
        
        didSet(newValue) {
            //  Working on the other way around ?!
            if newValue == false {
                self.textColor = UIColor.blackColor()
            }
            else {
                self.textColor = UIColor.lightGrayColor()
            }
            
        }
    }
    
    override func resignFirstResponder() -> Bool {
        self.textColor = UIColor.blackColor()
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        self.textColor = UIColor(hex: Colors.BlueColor)
        return super.becomeFirstResponder()
    }
    



    
    
}
