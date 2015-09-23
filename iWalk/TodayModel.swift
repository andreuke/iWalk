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
    let coreDataManager = CoreDataManager.instance
    
    // MARK: Properties
    var stepsCount = 0
    var caloriesCount = 0.0
    var distanceCount = 0.0
    var timeCount : NSTimeInterval?
    var goal = 10000.0 {
        didSet {
            self.saveGoal(goal)
        }
    }
    
        // Graph
    var values : [Double]?
    var labels = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
    
    // MARK: Queries
    func fetchTodayValues() {
        healthKitManager.currentSteps()
        healthKitManager.currentCalories()
        healthKitManager.currentDistance()
        healthKitManager.currentTime()
        healthKitManager.currentStepsDistribution()

        if let g = coreDataManager.fetchTodayGoal() {
            goal = g
        }
    }
    
    func fetchSessionValues() {
        Pedometer.instance.startPedometer()
        healthKitManager.currentStepsDistribution()
        
        if let g = coreDataManager.fetchSessionGoal() {
            Pedometer.instance.goal = g
        }
    }
    
    func stopQueries() {
        healthKitManager.stopQueries()
    }
    
    func saveGoal(goal: Double) {
        coreDataManager.persistTodayGoal(goal)
    }
}
