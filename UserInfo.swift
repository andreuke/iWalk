//
//  User.swift
//  iWalk
//
//  Created by Andrea Piscitello on 09/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class UserInfo {
    static let BIRTHDAY = "Birthday"
    static let GENDER = "Gender"
    static let HEIGHT = "Height"
    static let WEIGHT = "Weight"
    
    static let HEIGHT_MIN = 130
    static let HEIGHT_MAX = 230
    
    static let WEIGHT_MIN = 35
    static let WEIGHT_MAX = 135
    
    let healthKitManager = HealthKitManager.instance
    
    var ranges : [String:[String]] = [
        UserInfo.BIRTHDAY:["Today","Yesterday"],
        UserInfo.GENDER:["Male","Female"],
        UserInfo.HEIGHT:(UserInfo.HEIGHT_MIN...UserInfo.HEIGHT_MAX).map{String($0)+" cm"},
        UserInfo.WEIGHT: (UserInfo.WEIGHT_MIN...UserInfo.WEIGHT_MAX).map{String($0)+" kg"}
        ]
    

    
    // MARK: Properties
    var info : [String:String]
    
    // MARK: Inizialization
    init?() {
        
        self.info = healthKitManager.getUserInfo()
        
//        if !(UserInfo.HEIGHT_MIN...UserInfo.HEIGHT_MAX ~= self.info[HEIGHT]!) {
//            return nil
//        }
//        
//        if !(UserInfo.WEIGHT_MIN...UserInfo.WEIGHT_MAX ~= self.info[WEIGHT]!) {
//            return nil
//        }
    }
    
}