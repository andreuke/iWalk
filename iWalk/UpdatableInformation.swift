//
//  UpdatableInformation.swift
//  iWalk
//
//  Created by Andrea Piscitello on 16/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class UpdatableInformation {
    // MARK: Properties
    var value: String?
    var latestUpdate: NSDate?
    
    init(value: String?, latestUpdate: NSDate?) {
        self.value = value
        self.latestUpdate = latestUpdate
        
    }
}
