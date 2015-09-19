//
//  Notifications.swift
//  iWalk
//
//  Created by Andrea Piscitello on 16/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import Foundation

class Notifications {
    // MARK: UserInfo
    static let weightUpdated = "com.giadrea.notifications.weigthUpdated"
    static let heightUpdated = "com.giadrea.notifications.heigthUpdated"
    static let sexUpdated = "com.giadrea.notifications.sexUpdated"
    static let bmiUpdated = "com.giadrea.notifications.bmiUpdated"
    
    
    // MARK: Records
    
    struct mostStepsInADay {
        static let dayAndValueUpdated = "com.giadrea.notifications.mostStepsInADayUpdatedDay"
        static let hoursUpdated = "com.giadrea.notifications.mostStepsInADayUpdatedSteps"
    }
    
    struct averageDailySteps {
        static let valueUpdated = "com.giadrea.notifications.averageDailyStepsUpdatedDay"
        static let hoursUpdated = "com.giadrea.notifications.mostStepsInADayUpdatedSteps"
    }
    
    struct totalRecords {
        static let valueUpdated = "com.giadrea.notifications.totalLifetimeUpdatedSteps"
    }
    
    
    
    
}
