//
//  Colors.swift
//  iWalk
//
//  Created by Andrea Piscitello on 14/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class Colors {
    static let BlueColor = 0x0066FF

}

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
}
