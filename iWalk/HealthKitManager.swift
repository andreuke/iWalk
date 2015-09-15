//
//  HealthKitManager.swift
//  iWalk
//
//  Created by Andrea Piscitello on 14/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager {
    static let instance = HealthKitManager()
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    private init() {
        // TODO
    }
    
    // MARK: HealthKit Configuration
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = Set(arrayLiteral:HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKObjectType.workoutType()
        )
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = Set(arrayLiteral:
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKQuantityType.workoutType()
        )
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.giadrea.iWalk", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead, completion: { (success, error) -> Void in
            
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        })
    }
    
    func getUserInfo() -> [String:String]{
        
        
        var info = [String:String]()
        
        info[UserInfo.BIRTHDAY] = birthDayAndAge()
        info[UserInfo.GENDER] = biologicalSex()
        //        info[UserInfo.HEIGHT] = "\(height) cm"
        //        info[UserInfo.WEIGHT] =  "\(weight) kg"
        
        return info
    }
    
    func birthDayAndAge() -> String? {
        var age:Int?
        
        let birthDay: NSDate?
        
        do {
            try birthDay = healthKitStore.dateOfBirth()
            
            let today = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let differenceComponents = calendar.components(.Year, fromDate: birthDay!, toDate: today, options: NSCalendarOptions(rawValue: 0) )
            age = differenceComponents.year
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let birthDayString = dateFormatter.stringFromDate(birthDay!)
            
            return "\(birthDayString) (\(age!))"

        } catch {
            print("Error reading Birthday")
            return nil
        }
        
    }
    
    func biologicalSex() -> String? {
        let sex :HKBiologicalSexObject
        
        do {
            sex = try healthKitStore.biologicalSex()
            switch sex.biologicalSex {
            case .Female:
                return "Female"
            case .Male:
                return "Male"
            case .NotSet:
                return nil
            default:
                return nil
            }
        }
        catch {
            print("Error handling Biological Sex")
        }
        return nil
    }



//    func getPeriodicData(dataType: Int, period: Int) {
//        switch dataType {
//        case 0: {
//
//            }
//        }
//    }



}
