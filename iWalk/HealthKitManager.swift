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
    
    // MARK: Fetch Data
    func getUserInfo() -> (birthday: NSDate?, gender: String?){
        
        let birthday = birthDay()
        let gender = biologicalSex()
        
        return (birthday, gender)
    }
    
    func birthDay() -> NSDate? {
        // TODO: add request to internal database
        
        let birthDay: NSDate?
        
        do {
            try birthDay = healthKitStore.dateOfBirth()
            return birthDay
            
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
            
            let timestamp = weight?.endDate
            
            let weightInfo = UpdatableInformation(value: weight, latestUpdate: timestamp)
            
            UserInfo.instance?.updateWeight(weightInfo)
            
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
            let timestamp = height?.endDate
            
            let heightInfo = UpdatableInformation(value: height, latestUpdate: timestamp)
            
            UserInfo.instance?.updateHeight(heightInfo)
            
            
        })
    }
    
    // MARK: Save Data
    func saveBMISample(bmi:Double, date:NSDate ) {
        
        // 1. Create a BMI Sample
        let bmiType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
        let bmiQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: bmi)
        let bmiSample = HKQuantitySample(type: bmiType!, quantity: bmiQuantity, startDate: date, endDate: date)
        
        // 2. Save the sample in the store
        healthKitStore.saveObject(bmiSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print("Error saving BMI sample: \(error!.localizedDescription)")
            } else {
                print("BMI sample saved successfully!")
            }
        })
    }
    
    
    func saveHeightSample(height:Double, date:NSDate ) {
        
        // 1. Create a BMI Sample
        let heightSample = heightSampleFromDouble(height, date: date)
        
        // 2. Save the sample in the store
        healthKitStore.saveObject(heightSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print("Error saving Height sample: \(error!.localizedDescription)")
            } else {
                print("Height sample saved successfully!")
            }
        })
    }
    
    func saveWeightSample(weight:Double, date:NSDate ) {
        
        // 1. Create a BMI Sample
        let weightSample = weightSampleFromDouble(weight, date: date)
        
        // 2. Save the sample in the store
        healthKitStore.saveObject(weightSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print("Error saving Weight sample: \(error!.localizedDescription)")
            } else {
                print("Weight sample saved successfully!")
            }
        })
    }
    
    
    func heightSampleFromDouble(height: Double, date: NSDate) -> HKQuantitySample {
        let heightType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        let heightQuantity = HKQuantity(unit: HKUnit(fromString: "cm"), doubleValue: height)
        let heightSample = HKQuantitySample(type: heightType!, quantity: heightQuantity, startDate: date, endDate: date)
        return heightSample
    }
    
    func heightDoubleFromSample(height: HKQuantitySample) -> Double {
        return height.quantity.doubleValueForUnit(HKUnit.meterUnit())
    }
    
    
    func weightSampleFromDouble(weight: Double, date: NSDate) -> HKQuantitySample {
        let weightType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let weightQuantity = HKQuantity(unit: HKUnit(fromString: "kg"), doubleValue: weight)
        let weightSample = HKQuantitySample(type: weightType!, quantity: weightQuantity, startDate: date, endDate: date)
        
        return weightSample
    }
    
    func weightDoubleFromSample(weight: HKQuantitySample) -> Double {
        return weight.quantity.doubleValueForUnit(HKUnit.gramUnit())
    }

    
}