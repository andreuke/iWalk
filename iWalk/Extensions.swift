//
//  DateExtension.swift
//  iWalk
//
//  Created by Andrea Piscitello on 16/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

extension NSDate {
    func toDateAndAgeString() -> String {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let differenceComponents = calendar.components(.Year, fromDate: self, toDate: today, options: NSCalendarOptions(rawValue: 0) )
        let age = differenceComponents.year
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let birthDayString = dateFormatter.stringFromDate(self)
        return "\(birthDayString) (\(age))"
        
        
    }
    
    func isToday() -> Bool{
        let cal = NSCalendar.currentCalendar()
        var components = cal.components([.Day, .Month, .Year, .Era], fromDate: NSDate())
        let today = cal.dateFromComponents(components)!
        
        components = cal.components([.Day, .Month, .Year, .Era], fromDate:self);
        let otherDate = cal.dateFromComponents(components)!
        
        if(today.isEqualToDate(otherDate)) {
            return true
        }
        return false
    }
}


extension Int {
    var addSpaceSeparator:String {
        let nf = NSNumberFormatter()
//        nf.groupingSeparator = NSLocale.currentLocale().objectForKey(NSLocaleGroupingSeparator) as! String
        nf.groupingSeparator = ","
    
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return nf.stringFromNumber(self)!
    }
}

// MARK: Matrix Implementation
struct Matrix2D<KeyElem:Hashable, Value> {
    
    var _storage:[KeyElem:[KeyElem:Value]] = [:]
    
    subscript(x:KeyElem, y:KeyElem) -> Value? {
        get {
            return _storage[x]?[y]
        }
        set(val) {
            if _storage[x] == nil {
                _storage[x] = [:]
            }
            _storage[x]![y] = val
        }
    }
}

