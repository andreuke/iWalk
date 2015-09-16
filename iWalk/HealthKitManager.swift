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
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKObjectType.workoutType()
        )
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = Set(arrayLiteral:
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKQuantityType.workoutType(),
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
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
    
    func getUserInfo() -> (birthday: String?, gender: String?){
        
        let birthday = birthDayAndAge()
        let gender = biologicalSex()
        //        info[UserInfo.HEIGHT] = "\(height) cm"
        //        info[UserInfo.WEIGHT] =  "\(weight) kg"
        
        return (birthday, gender)
    }
    
    func birthDayAndAge() -> String? {
        // TODO: add request to internal database
        
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

    
    
    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!)
    {
        
        // 1. Build the Predicate
        let past = NSDate.distantPast() 
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    completion(nil,queryError)
                    return;
                }
                
                // Get the first sample
                let mostRecentSample = results!.first as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample,nil)
                }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
    func fetchWeight() {
        // 1. Construct an HKSampleType for weight
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        // 2. Call the method to read the most recent weight sample
        self.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }

            // 3. Format the weight to display it on the screen
            let weight = mostRecentWeight as? HKQuantitySample;
            if let kilograms = weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
                let weightFormatter = NSMassFormatter()
                weightFormatter.forPersonMassUse = true;
                let weightString = weightFormatter.stringFromKilograms(kilograms)
                let timestamp = weight?.endDate
                
                let weightInfo = UpdatableInformation(value: weightString, latestUpdate: timestamp)
                
                UserInfo.instance?.updateWeight(weightInfo)
            }
        })
    }

    func fetchHeight() {
        
        // 1. Construct an HKSampleType for Height
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        
        // 2. Call the method to read the most recent Height sample
        self.readMostRecentSample(sampleType!, completion: { (mostRecentHeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading height from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
        
            let height = mostRecentHeight as? HKQuantitySample;
            
            // 3. Format the height to display it on the screen
            if let meters = height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
                let heightFormatter = NSLengthFormatter()
                heightFormatter.forPersonHeightUse = true;
                let heightString = heightFormatter.stringFromMeters(meters);
                let timestamp = height?.endDate
                
                let heightInfo = UpdatableInformation(value: heightString, latestUpdate: timestamp)
                
                UserInfo.instance?.updatHeight(heightInfo)
            }
            
    
        })
    }


    
}