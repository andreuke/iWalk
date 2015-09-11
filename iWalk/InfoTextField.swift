//
//  InfoTextField.swift
//  iWalk
//
//  Created by Andrea Piscitello on 10/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class InfoTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: "onEditingBegin:", forControlEvents: UIControlEvents.EditingDidBegin)
        self.addTarget(self, action: "onEditingEnd:", forControlEvents: UIControlEvents.EditingDidEnd)

    }

    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        switch action {
//            case "paste:","cut:","share:","select:":
//                return false
//            default:
//                return false
//        }
//
//        return super.canPerformAction(action, withSender: sender)
        return false

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
    
    func onEditingBegin(sender: InfoTextField) {
        self.textColor = UIColor.blueColor()
    }
    
    func onEditingEnd(sender: InfoTextField) {
        self.textColor = UIColor.blackColor()
    }


    
    
    
    
    


}
