//
//  CoreDataManager.swift
//  iWalk
//
//  Created by Andrea Piscitello on 18/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    
    private init() {
    }
    
    // MARK: Fetch Data
    func fetchBirthday() -> NSDate?{
        if let results = fetchData("Birthday") {
            if let bDay = results[results.endIndex-1].valueForKey("value") as? NSDate {
                return bDay
            }
        }
        
        return nil
    }
    
    func fetchGender() -> String?{
        if let results = fetchData("Gender") {
            if let gender = results[results.endIndex-1].valueForKey("value") as? String {
                return gender
            }
        }
        
        return nil
    }
    
    func fetchHeight() -> (heightDouble: Double, latestUpdate: NSDate)?{
        if let results = fetchData("Height") {
            if let height = results[results.endIndex-1].valueForKey("value") as? Double {
                let latestUpdate = results[results.endIndex-1].valueForKey("latestUpdate") as? NSDate
                return (height, latestUpdate!)
            }
        }
        
        return nil
    }
    
    func fetchWeight() -> (weightDouble: Double, latestUpdate: NSDate)?{
        if let results = fetchData("Weight") {
            if let weight = results[results.endIndex-1].valueForKey("value") as? Double {
                let latestUpdate = results[results.endIndex-1].valueForKey("latestUpdate") as? NSDate
                return (weight, latestUpdate!)
            }
        }
        
        return nil
    }
    
    func fetchData(key: String) -> [NSManagedObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:key)
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as?[NSManagedObject]
            if fetchedResults?.count > 0 {
                return fetchedResults
            }
        }
        catch {
            print("Could not fetch \(key) locally")
        }
        return nil
        
    }
    
    
    // MARK: Persist Data
    func persistBirthday(birthday: NSDate) {
        persistData("Birthday", value: birthday)
    }
    
    
    func persistGender(gender: NSString) {
        persistData("Gender", value: gender)
    }
    
    
    func persistHeight(height: Double) {
        persistData("Height", value: height)
    }
    
    func persistWeight(weight: Double) {
        persistData("Weight", value: weight)
    }
    
    func persistData(key: String, value: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName(key, inManagedObjectContext: managedContext)
        let entry = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        entry.setValue(value, forKey: "value")
        entry.setValue(NSDate(), forKey: "latestUpdate")
        
        
        do {
            try managedContext.save()
            print("\(key) saved locally")
        }
        catch{
            print("Could not save \(key) locally")
        }
    }
    
    func persistGender() {
        
    }
    
    
    
    
    
}
