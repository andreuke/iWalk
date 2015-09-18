//
//  User.swift
//  iWalk
//
//  Created by Andrea Piscitello on 09/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import HealthKit

class UserInfo : NSObject{
    
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
    var bmi : UpdatableInformation?
    var bmiHasToBeChanged : Bool = false
    
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

    var tableView = UITableView()
    
    // MARK: Inizialization
    private override init() {
        super.init()
        //        self.info = [UpdatableInformation?](count:ranges.count, repeatedValue: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "willUpdateBmi" , name: Notifications.heightUpdated, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "willUpdateBmi" , name: Notifications.weightUpdated, object: nil)
        
        
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
        // TODO: updateGender
    }
    
    // Weight
    func fetchLatestWeight() {
        healthKitManager.fetchWeight()
        // TODO: fetchFromDatabase
    }
    
    // Height
    func fetchLatestHeight() {
        healthKitManager.fetchHeight()
        // TODO: fetchFromDatabase
    }
    
    // MARK: Update information
    func updateGender() -> Bool {
        // TODO: implementation
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.sexUpdated, object: nil)
        return true
    }
    
    
    func updateWeight(newWeight: UpdatableInformation) -> Bool {
        if(newWeight.latestUpdate == nil) {
            return false
        }
        
        if let currentWeightUpdate = self.weight?.latestUpdate {
            if(currentWeightUpdate < newWeight.latestUpdate) {
                self.weight = newWeight
            }
            else {
                return false
            }
        }
            // If current is not available
        else {
            self.weight = newWeight
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.weightUpdated, object: nil)
        return true
    }
    
    func updateHeight(newHeight: UpdatableInformation) -> Bool {
        if(newHeight.latestUpdate == nil) {
            return false
        }
        
        if let currentHeightUpdate = self.height?.latestUpdate {
            if(currentHeightUpdate < newHeight.latestUpdate) {
                self.height = newHeight
            }
            else {
                return false
            }
        }
        // If current is not available
        else {
            self.height = newHeight
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.heightUpdated, object: nil)
        return true
        
    }
    
    func willUpdateBmi() {
        self.bmiHasToBeChanged = true
    }
    
    func updateBmi() {
        if self.bmiHasToBeChanged == false {
            return
        }
        
        guard let weightValue = weight?.value?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) else {
            return
        }
        guard let heightValue = height?.value?.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Centi)) else {
            return
        }

        
        let bmiValue = weightValue / (heightValue * heightValue)
        let bmiSample = healthKitManager.bmiSampleFromDouble(bmiValue, date: NSDate())
        self.bmi = UpdatableInformation(value: bmiSample, latestUpdate: bmiSample.endDate)
        
        healthKitManager.saveBMISample(bmiValue, date: bmiSample.endDate)
        
        
        self.bmiHasToBeChanged = false
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.bmiUpdated, object: nil)
    }
    
    
    // MARK: Persist Data
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