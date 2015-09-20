//
//  ClickableRangeLabel.swift
//  iWalk
//
//  Created by Andrea Piscitello on 17/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class ClickableRangeLabel:PRLabel {
    
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
            if newValue == true {
                self.textColor = UIColor.blackColor()
            }
            else {
                self.textColor = UIColor.lightGrayColor()
            }
            
        }
    }
    
    
    
    
    
    
}
