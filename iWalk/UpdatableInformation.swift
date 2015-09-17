//
//  UpdatableInformation.swift
//  iWalk
//
//  Created by Andrea Piscitello on 16/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import HealthKit

class UpdatableInformation {
    // MARK: Properties
    var value: HKQuantitySample?
    var latestUpdate: NSDate?
    
    init(value: HKQuantitySample?, latestUpdate: NSDate?) {
        self.value = value
        self.latestUpdate = latestUpdate
        
    }

}
