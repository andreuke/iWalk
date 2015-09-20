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
    static let weightHistoryUpdated = "com.giadrea.notifications.weightHistoryUpdated"
    
    
    // MARK: Records
    
    struct mostStepsInADay {
        static let dayAndValueUpdated = "com.giadrea.notifications.mostStepsInADay.dayAndValueUpdated"
        static let hoursUpdated = "com.giadrea.notifications.mostStepsInADay.hoursUpdated"
    }
    
    struct averageDailySteps {
        static let valueUpdated = "com.giadrea.notifications.averageDailySteps.valueUpdated"
        static let hoursUpdated = "com.giadrea.notifications.averageDailySteps.hoursUpdated"
    }
    
    struct totalRecords {
        static let stepsUpdated = "com.giadrea.notifications.totalRecords.stepsUpdated"
        static let caloriesUpdated = "com.giadrea.notifications.totalRecords.caloriesUpdated"
        static let distanceUpdated = "com.giadrea.notifications.totalRecords.distanceUpdated"
    }
    
    // MARK: Stats
    struct stats {
        static let stepsUpdated = "com.giadrea.notifications.stats.stepsUpdated"
        static let caloriesUpdated = "com.giadrea.notifications.stats.caloriesUpdated"
        static let distanceUpdated = "com.giadrea.notifications.stats.distanceUpdated"
    }
    
    
}
