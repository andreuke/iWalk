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
        
        fetchAllInfo()
        
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
    
    // MARK: Update information
    func updateWeight(newWeight: UpdatableInformation) {
        if(newWeight.latestUpdate == nil) {
            return
        }
        
        if let currentWeightUpdate = self.info[Attribute.Weight.rawValue]?.latestUpdate {
            if(currentWeightUpdate < newWeight.latestUpdate) {
                self.info[Attribute.Weight.rawValue] = newWeight
            }
        }
            // If current is not available
        else {
            self.info[Attribute.Weight.rawValue] = newWeight
        }
        sleep(2)
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.weightUpdated, object: nil)
        
    }
    
    
    
    
    
}