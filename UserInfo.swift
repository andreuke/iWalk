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
    
    
    
//    struct Attribute {
//        var key: String
//        var value: String
//        
//    }
    
    var ranges : [String:[String]] = [
        UserInfo.BIRTHDAY:["Today","Yesterday"],
        UserInfo.GENDER:["Male","Female"],
        UserInfo.HEIGHT:(UserInfo.HEIGHT_MIN...UserInfo.HEIGHT_MAX).map{String($0)+" cm"},
        UserInfo.WEIGHT: (UserInfo.WEIGHT_MIN...UserInfo.WEIGHT_MAX).map{String($0)+" kg"}
        ]
    

    
    // MARK: Properties
    var info : [String:String]
    
    // MARK: Inizialization
    init?(birthday: String?, gender: String?, height: Int?, weight: Int?) {
        info = [String:String]()
        
        if !(UserInfo.HEIGHT_MIN...UserInfo.HEIGHT_MAX ~= height!) {
            return nil
        }
        
        if !(UserInfo.WEIGHT_MIN...UserInfo.WEIGHT_MAX ~= weight!) {
            return nil
        }
        
        
        self.info[UserInfo.BIRTHDAY] = birthday
        self.info[UserInfo.GENDER] = gender
        self.info[UserInfo.HEIGHT] = "\(height!) cm"
        self.info[UserInfo.WEIGHT] =  "\(weight!) kg"
        
    }
    
}