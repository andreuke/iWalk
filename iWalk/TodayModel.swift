//
//  TodayModel.swift
//  iWalk
//
//  Created by Andrea Piscitello on 21/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class TodayModel {
    enum Attribute : Int {
    case Steps = 0
    case Calories, Distance
    }
    
    
    static let instance = TodayModel()
    
    private init() {
        
    }
    
    // MARK: Constants
    let healthKitManager = HealthKitManager.instance
    
    // MARK: Properties
    var stepsCount = 0
    var caloriesCount = 0.0
    var distanceCount = 0.0
    var timeCount : NSTimeInterval?
    
        // Graph
    var values : [Double]?
    var labels = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
    
    // MARK: Methods
    func resetCounters() {
        stepsCount = 0
        caloriesCount = 0.0
        distanceCount = 0.0
        timeCount = nil
    }
    
    // MARK: Queries
    func fetchTodayValues() {
        healthKitManager.currentSteps()
        healthKitManager.currentCalories()
        healthKitManager.currentDistance()
        healthKitManager.currentTime()
        healthKitManager.currentStepsDistribution()
    }
    
    func fetchSessionValues() {
        
    }
}
