//
//  User.swift
//  iWalk
//
//  Created by Andrea Piscitello on 09/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import HealthKit

class UserInfo {
    
    static let instance = UserInfo()
    
    enum Attribute : Int {
        case Birthday = 0
        case Gender
        case Height
        case Weight
        case _count
        
        var description : String? {
            switch self {
            case .Birthday: return "Birthday"
            case .Gender: return "Gender"
            case .Height: return "Height"
            case .Weight: return "Weight"
            case ._count: return nil
            }
        }
    }
    
    var birthday : NSDate?
    var gender : String?
    var weight : UpdatableInformation?
    var height : UpdatableInformation?
    var BMI : UpdatableInformation?
    
    
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
    //
    //
    //    var info : [UpdatableInformation?]
    var tableView = UITableView()
    
    // MARK: Inizialization
    private init?() {
        //        self.info = [UpdatableInformation?](count:ranges.count, repeatedValue: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBMI" , name: Notifications.heightUpdated, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBMI" , name: Notifications.weightUpdated, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBMI" , name: Notifications.sexUpdated, object: nil)
        
        
        //        fetchAllInfo()
        
        //        if !(UserInfo.HEIGHT_MIN...UserInfo.HEIGHT_MAX ~= self.info[HEIGHT]!) {
        //            return nil
        //        }
        //
        //        if !(UserInfo.WEIGHT_MIN...UserInfo.WEIGHT_MAX ~= self.info[WEIGHT]!) {
        //            return nil
        //        }
    }
    
    func attributeString(index: Int) -> String?{
        
        switch index {
        case Attribute.Birthday.rawValue:
            return self.birthday?.toDateAndAgeString()
        case Attribute.Gender.rawValue:
            return gender
        case Attribute.Height.rawValue:
            if let meters = height?.value?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
                let heightFormatter = NSLengthFormatter()
                heightFormatter.forPersonHeightUse = true
                let heightString = heightFormatter.stringFromMeters(meters)
                return heightString
            }
            return nil
        case Attribute.Weight.rawValue:
            if let kilograms = self.weight?.value?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
                let weightFormatter = NSMassFormatter()
                weightFormatter.forPersonMassUse = true;
                let weightString = weightFormatter.stringFromKilograms(kilograms)
                return weightString
            }
            return nil
        default: return nil
        }
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
        self.birthday = infoTuple.birthday
        self.gender = infoTuple.gender
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
        
        if let currentWeightUpdate = self.weight?.latestUpdate {
            if(currentWeightUpdate < newWeight.latestUpdate) {
                self.weight = newWeight
            }
            else {
                return
            }
        }
            // If current is not available
        else {
            self.weight = newWeight
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.weightUpdated, object: nil)
        
    }
    
    func updateHeight(newHeight: UpdatableInformation) {
        if(newHeight.latestUpdate == nil) {
            return
        }
        
        if let currentHeightUpdate = self.height?.latestUpdate {
            if(currentHeightUpdate < newHeight.latestUpdate) {
                self.height = newHeight
            }
            else {
                return
            }
        }
            // If current is not available
        else {
            self.height = newHeight
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
    
    func persistAllData() {
        persistBirthday()
        persistGender()
        persistHeight()
        persistWeight()
    }
    
    func persistBirthday() {
        
    }
    
    func persistGender() {
        
    }
    
    func persistHeight() {
        healthKitManager.saveHeightSample(self.height!.value!.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix((.Centi))), date: NSDate())
    }
    
    func persistWeight() {
        healthKitManager.saveWeightSample(self.weight!.value!.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)), date: NSDate())
    }
    
    
    
    
    
}