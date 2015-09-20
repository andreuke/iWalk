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
    
    struct stepsStruct {
        var steps: [Double]?
        var labels: [String]?
        
        var average : Int? {
            get {
                if let _ = steps {
                    var total = 0.0
                    for s in steps! {
                        total += s
                    }
                    return Int(round(total/Double(steps!.count)))
                }
                return nil
            }
        }
        
        var total: Int? {
            get {
                if let _ = steps {
                    var total = 0.0
                    for s in steps! {
                        total += s
                    }
                    return Int(total)
                }
                return nil
            }
        }
    }
    
    struct caloriesStruct {
        var calories: [Double]?
        var labels: [String]?
        
        var average : Int? {
            get {
                if let _ = calories {
                    var total = 0.0
                    for s in calories! {
                        total += s
                    }
                    return Int(round(total/Double(calories!.count)))
                }
                return nil
            }
        }
        
        var total: Int? {
            get {
                if let _ = calories {
                    var total = 0.0
                    for s in calories! {
                        total += s
                    }
                    return Int(total)
                }
                return nil
            }
        }
    }

    struct distanceStruct {
        var distance: [Double]?
        var labels: [String]?
        
        var average : Int? {
            get {
                if let _ = distance {
                    var total = 0.0
                    for s in distance! {
                        total += s
                    }
                    return Int(round(total/Double(distance!.count)))
                }
                return nil
            }
        }
        
        var total: Int? {
            get {
                if let _ = distance {
                    var total = 0.0
                    for s in distance! {
                        total += s
                    }
                    return Int(total)
                }
                return nil
            }
        }
    }
    
    
    func fetchAllData(period: Int) {
        healthKitManager.periodicAttributeQuery(period, attribute: StatsModel.Attributes.Steps.rawValue)
        healthKitManager.periodicAttributeQuery(period, attribute: StatsModel.Attributes.Calories.rawValue)
        healthKitManager.periodicAttributeQuery(period, attribute: StatsModel.Attributes.Distance.rawValue)
        
    }

}
