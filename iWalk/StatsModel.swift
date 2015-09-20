//
//  StatsModel.swift
//  iWalk
//
//  Created by Andrea Piscitello on 20/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class StatsModel {
    static let instance = StatsModel()
    
    let healthKitManager = HealthKitManager.instance
    
    
    private init() {
        
    }
    
    var stepsData = stepsStruct()
    var caloriesData = caloriesStruct()
    var distanceData = distanceStruct()
    
    
    enum Attributes: Int {
        case Steps = 0
        case Calories
        case Distance
    }
    
    enum Period: Int {
        case Week = 0
        case Month
        case Year
    }
    
    func getProva() -> Int {
        return 0
    }
    
    struct stepsStruct {
        var steps = [[Double]?](count : 3, repeatedValue : nil)
        var labels = [[String]?](count : 3, repeatedValue : nil)
        
        var average : [Double]? {
            get {
                return StatsModel.instance.getAverage(steps)
            }
        }
        
        var total: [Double]? {
            get {
                return StatsModel.instance.getTotal(steps)
            }
            
        }
    }
    
    
    
    struct caloriesStruct {
        var calories = [[Double]?](count : 3, repeatedValue : nil)
        var labels = [[String]?](count : 3, repeatedValue : nil)
        
        var average : [Double]? {
            get {
                return StatsModel.instance.getAverage(calories)
            }
        }
        
        var total: [Double]? {
            get {
                return StatsModel.instance.getTotal(calories)
            }
        }
    }
    
    struct distanceStruct {
        var distance = [[Double]?](count : 3, repeatedValue : nil)
        var labels = [[String]?](count : 3, repeatedValue : nil)
        
        var average : [Double]? {
            get {
                return StatsModel.instance.getAverage(distance)
            }
        }
        
        var total: [Double]? {
            get {
                return StatsModel.instance.getTotal(distance)
            }
        }
    }
    
    func getAverage(values: [[Double]?])-> [Double]? {
        
        var returnValues = [Double](count : 3, repeatedValue : 0)
        
        for i in 0..<values.count  {
            if let vPeriod = values[i] {
                var total = 0.0
                for v in vPeriod {
                    total += v
                }
                var result = total/Double(vPeriod.count)
                if(i == 0 || i == 1) {
                    result = round(result)
                }
                returnValues[i] = result
            }
            
        }
        return returnValues
        
        
        
    }
    
    func getTotal(values: [[Double]?]) -> [Double]? {
        
        var returnValues = [Double](count : 3, repeatedValue : 0)
        
        for i in 0..<values.count  {
            if let vPeriod = values[i] {
                var total = 0.0
                for v in vPeriod {
                    total += v
                }
                var result = total
                if(i == 0 || i == 1) {
                    result = round(result)
                }
                returnValues[i] = result
            }

        }
        return returnValues
    }
    
    
    func fetchAllData(period: Int) {
        healthKitManager.periodicAttributeQuery(period, attribute: StatsModel.Attributes.Steps.rawValue)
        healthKitManager.periodicAttributeQuery(period, attribute: StatsModel.Attributes.Calories.rawValue)
        healthKitManager.periodicAttributeQuery(period, attribute: StatsModel.Attributes.Distance.rawValue)
        
    }
    
}

