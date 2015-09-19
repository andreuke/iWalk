//
//  RecordsModel.swift
//  iWalk
//
//  Created by Andrea Piscitello on 19/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class RecordsModel {
    static let instance = RecordsModel()
    
    let healthKitManager = HealthKitManager.instance
    

    struct mostStepsInADayStruct {
        var day : NSDate?
        var value : Int?
        var hours = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
        var steps : [Int]?
    }
    var mostStepsInADay = mostStepsInADayStruct()
    
    struct averageDailyStepsStruct {
        var value : Int?
    }
    var averageDailySteps = averageDailyStepsStruct()
    
    struct totalRecords {
        
    }
    
    private init() {
        
    }
    
    func fetchAllRecords() {
        self.fetchMostStepsInADay()
    }
    
    func fetchMostStepsInADay() {
        healthKitManager.mostStepsInADay()
    }
    
    func fetchAverageDailySteps() {
        
    }
    
    func fetchLifeTimeTotal() {
        
    }
    
}
