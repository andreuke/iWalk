//
//  User.swift
//  iWalk
//
//  Created by Andrea Piscitello on 09/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class UserInfo {
    
    static let instance = UserInfo()
    
    enum Attribute:Int {
        case Birthday = 0
        case Gender, Height, Weight
        
        var description : String {
            switch self {
            case .Birthday: return "Birthday"
            case .Gender: return "Gender"
            case .Height: return "Height"
            case .Weight: return "Weight"
                
            }
        }
    }
    
    static let HEIGHT_MIN = 130
    static let HEIGHT_MAX = 230
    
    static let WEIGHT_MIN = 35
    static let WEIGHT_MAX = 135
    
    let healthKitManager = HealthKitManager.instance
    
    var ranges : [[String]] = [
        ["Today","Yesterday"],
        ["Male","Female"],
        (UserInfo.HEIGHT_MIN...UserInfo.HEIGHT_MAX).map{String($0)+" cm"},
        (UserInfo.WEIGHT_MIN...UserInfo.WEIGHT_MAX).map{String($0)+" kg"}
    ]
    
    
    var info : [UpdatableInformation?]
    var tableView = UITableView()
    
    // MARK: Inizialization
    private init?() {
        self.info = [UpdatableInformation?](count:ranges.count, repeatedValue: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBMI" , name: Notifications.heightUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBMI" , name: Notifications.weightUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBMI" , name: Notifications.sexUpdated, object: nil)
        
        
        //        fetchAllInfo()
        
        //        if !(UserInfo.HEIGHT_MIN...UserInfo.HEIGHT_MAX ~= self.info[HEIGHT]!) {
        //            return nil
        //        }
        //
        //        if !(UserInfo.WEIGHT_MIN...UserInfo.WEIGHT_MAX ~= self.info[WEIGHT]!) {
        //            return nil
        //        }
    }
    
    
    // MARK: Fetch Information
    func fetchAllInfo() {
        fetchCharachteristics()
        fetchLatestWeight()
        fetchLatestHeight()
    }
    
    // Birthday and Gender
    func fetchCharachteristics() {
        let infoTuple = healthKitManager.getUserInfo()
        self.info[Attribute.Birthday.rawValue] = UpdatableInformation(value: infoTuple.birthday, latestUpdate: nil)
        self.info[Attribute.Gender.rawValue] = UpdatableInformation(value: infoTuple.gender, latestUpdate: nil)
    }
    
    // Weight
    func fetchLatestWeight() {
        healthKitManager.fetchWeight()
        // TODO fetchFromDatabase
    }
    
    // Height
    func fetchLatestHeight() {
        healthKitManager.fetchHeight()
        // TODO fetchFromDatabase
    }
    
    // MARK: Update information
    func updateWeight(newWeight: UpdatableInformation) {
        if(newWeight.latestUpdate == nil) {
            return
        }
        
        if let currentWeightUpdate = self.info[Attribute.Weight.rawValue]?.latestUpdate {
            if(currentWeightUpdate < newWeight.latestUpdate) {
                self.info[Attribute.Weight.rawValue] = newWeight
            }
            else {
                return
            }
        }
            // If current is not available
        else {
            self.info[Attribute.Weight.rawValue] = newWeight
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.weightUpdated, object: nil)
        
    }
    
    func updatHeight(newHeight: UpdatableInformation) {
        if(newHeight.latestUpdate == nil) {
            return
        }
        
        if let currentHeightUpdate = self.info[Attribute.Height.rawValue]?.latestUpdate {
            if(currentHeightUpdate < newHeight.latestUpdate) {
                self.info[Attribute.Height.rawValue] = newHeight
            }
            else {
                return
            }
        }
            // If current is not available
        else {
            self.info[Attribute.Height.rawValue] = newHeight
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.heightUpdated, object: nil)
        
    }
    
    func updateBMI() {
        // TODO: save directly kilograms
        
//        if (info[Attribute.Weight] != nil  && info[Attribute.Height] != nil) {
//            // 1. Get the weight and height values from the samples read from HealthKit
//            let weightInKilograms = weight!.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo))
//            let heightInMeters = height!.quantity.doubleValueForUnit(HKUnit.meterUnit())
//            // 2. Call the method to calculate the BMI
//            bmi  = calculateBMIWithWeightInKilograms(weightInKilograms, heightInMeters: heightInMeters)
//        }
//        // 3. Show the calculated BMI
//        var bmiString = kUnknownString
//        if bmi != nil {
//            bmiLabel.text =  String(format: "%.02f", bmi!)
//        }
    }
    
    
    
    
    
}