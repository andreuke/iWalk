//
//  Pedometer.swift
//  iWalk
//
//  Created by Andrea Piscitello on 21/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import CoreMotion

class Pedometer {
    static let instance = Pedometer()
    
    // MARK: Interfaces
    let todayModel = TodayModel.instance
    let healthKitManager = HealthKitManager.instance
    let coreMotionManager = CMMotionManager()
    
    // MARK: Attributes
    var steps = 0.0
        {
        didSet {
            if let heightSample = UserInfo.instance.height?.value {
                let height = healthKitManager.heightDoubleFromSample(heightSample)
                distance = 0.414 * height * steps / 1000.0 / 1000.0
                
                if let weightSample = UserInfo.instance.weight?.value {
                    let hours = timerSec/60.0/60.0
                    let speed = distance / hours

                    let weight = healthKitManager.weightDoubleFromSample(weightSample)
//                    calories = 0.781 * distance * weight
                    let factorA = 0.0215 * speed * speed * speed
                    let factorB = 0.1765 * speed * speed
                    let factorC = 0.8710 * speed
                    calories = (factorA  - factorB + factorC + 1.4577) * weight * hours
                    
                    print("steps: \(steps), distance: \(distance), calories: \(calories), time: \(timerSec)")

                }
                
                
                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.session.stepsUpdated, object: nil)
            }
        }
    }
    
    var calories = 0.0
    var distance = 0.0
    var startTime : NSDate?
    var timerSec : NSTimeInterval = 0.0
    
    // MARK: Constants
    let FILTER_SIZE = 4           // shift-register dimension for digital filter
    let NOISE_QUANTITY = 10
    let NOISE_FRACTION = 10       // experimental value to ignore HF noise. It represents the fraction of the greatest |max-min|
    let MAX_STEPS_PER_SECOND = 5
    let MIN_STEPS_PER_SECOND  = 0.5
    let FREQUENCY = 50.0                 // in Hz
    
    // Axis
    let X = 0
    let Y = 1
    let Z = 2
    
    
    let MIN_INTERVAL : Int
    let MAX_INTERVAL : Int
    
    // MARK: Variables
    var max_candidate = [Int](count: 3, repeatedValue: 0)
    var min_candidate = [Int](count: 3, repeatedValue: 0)
    var max_value = [Int](count: 3, repeatedValue: 0)
    var min_value = [Int](count: 3, repeatedValue: 0)
    var threshold = [Int](count: 3, repeatedValue: 0)
    var active = [Bool](count: 3, repeatedValue: false)   // active axis
    var result = [Int](count: 3, repeatedValue: 0)       // new values
    
    var old : [[Int]]
    
    var samples = 0                // number of samples acquired
    var interval = 0              // interval between a step and the next one

    
    var most_active = -1           // indicates the most active axis
    var buffer_filling = 0         // used for the first three steps of the digital filtering
    var noise = 0                  // quantity of noise to be overcame for filtering purposes
    
    
    
    private init() {
        MIN_INTERVAL = Int(FREQUENCY/Double(MAX_STEPS_PER_SECOND))
        MAX_INTERVAL = Int(FREQUENCY/MIN_STEPS_PER_SECOND)
        old = [[Int]](count: FILTER_SIZE - 1, repeatedValue: [Int](count: 3, repeatedValue: 0))
    }
    
   
    
    // MARK: Pedometer METHODS
    func startPedometer() {

        startTime = NSDate()
        resetValues()
        
        if coreMotionManager.accelerometerAvailable {
            let queue = NSOperationQueue()
            coreMotionManager.accelerometerUpdateInterval = 1/FREQUENCY
            coreMotionManager.startAccelerometerUpdatesToQueue(queue) {
                data, error in
                self.digital_filtering()
                self.min_max_election()
                
                if(self.samples == 10) {
                    self.threshold_update()
                }
                
                self.shift_register_update()
                self.get_accelerations((data?.acceleration)!)
                self.most_active_axis_detection()
                self.step_recognition()
                
                self.interval++
                self.samples++
                
                self.timerSec = NSDate().timeIntervalSinceDate(self.startTime!)
            
//                print("x: \(self.result[0]) y: \(self.result[1]) z: \(self.result[2]) ")
//                print(self.steps)
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    // update UI here
                }
                
            }
        }

    }
    
    func resetValues() {
        for i in 0..<3 {
            max_candidate[i] = -1000000
            min_candidate[i] = 1000000
            max_value[i] = 0
            min_value[i] = 0
            threshold[i] = 0
            active[i] = false
            result[i] = 0
            
            old[i][X] = 0
            old[i][Y] = 0
            old[i][Z] = 0
        }
    }
    
    // Mobile mean on FITER_PRECISION sample
    func digital_filtering() {
        
        if(buffer_filling < FILTER_SIZE) {                  // Manage the first three iterations
            buffer_filling++                               // using only the filled buffer cells
        }
        
        for i in 0..<3 {
            var sum = result[i]
            for j in 0..<buffer_filling-1 {
                sum += old[j][i]
            }
            result[i] = Int(Double(sum)/Double(buffer_filling))
        }
    }
    
    // Manage the election of max and min for the next 50 samples
    func min_max_election() {
        for i in 0..<3 {
            
            if(result[i] > max_candidate[i]) {
                max_candidate[i] = result[i]
            }
            if(result[i] < min_candidate[i]) {
                min_candidate[i] = result[i]
            }
        }
    }
    
    // Define the precision to be overcame in order to ignore High-Frequency Noise
    func dinamic_precision_setting() {
        var current = 0
        
        // Calculate the max{ |Xmax-Xmin|, |Ymax-Ymin|, |Zmax, Zmin| }
        for i in 0..<3 {
            if( abs(max_value[i] - min_value[i]) > current) {
                current = abs(max_value[i] - min_value[i])
            }
        }
        
        noise = current/NOISE_FRACTION
    }
    
    
    // Manage the update of max, min and threshold
    func threshold_update() {
        samples = 0
        
        for i in 0..<3 {
            max_value[i] = max_candidate[i]
            min_value[i] = min_candidate[i]
            
            threshold[i] = (max_value[i] + min_value[i])/2
            
            let change = min_candidate[i]
            min_candidate[i] = max_candidate[i]
            max_candidate[i] = change
            
            dinamic_precision_setting()
        }
    }
    
    // Updates the shift register used for digital filter
    func shift_register_update() {
        for i in 0..<3 {
            old[2][i] = old[1][i]
            old[1][i] = old[0][i]
            old[0][i] = result[i]

        }
    }
    
    // Acquires the X,Y,Z axis values from accelerometer
    func get_accelerations(acceleration: CMAcceleration) {
        var temp = [Int](count: 3, repeatedValue: 0)
        temp[X] = Int(acceleration.x*64)
        temp[Y] = Int(acceleration.y*64)
        temp[Z] = Int(acceleration.z*64)
        
        for i in 0..<3 {
            
            if( abs(result[i] - temp[i]) > noise ) {
                result[i] = temp[i]
                active[i] = true
            }
        }
    }
    
    func roundWithDigits(number: Double) -> Double {
        let zeros = 100.0
        return Double(round(number * zeros)/zeros)
    }
    
    // Recognize the biggest difference of acceleration among the three axis
    func most_active_axis_detection() {
        if(active[X] &&
            abs(result[X] - old[0][X]) >= abs(result[Y] - old[0][Y]) &&
            abs(result[X] - old[0][X]) >= abs(result[Z] - old[0][Z])) {
                most_active = X
        }
        else if(active[Y] &&
            abs(result[Y] - old[0][Y]) >= abs(result[X] - old[0][X]) &&
            abs(result[Y] - old[0][Y]) >= abs(result[Z] - old[0][Z])) {
                most_active = Y
        }
        else if(active[Z] &&
            abs(result[Z] - old[0][Z]) >= abs(result[Y] - old[0][Y]) &&
            abs(result[Z] - old[0][Z]) >= abs(result[X] - old[0][X])) {
                most_active = Z
        }
        else {
            most_active = -1
        }
        
        for i in 0..<3 {
            active[i] = false
        }

    }
    
    // Implements the step recognition logic
    func step_recognition() {
        if(0 <= most_active && most_active <= 2) {
            if(old[0][most_active] > threshold[most_active] &&
                threshold[most_active] > result[most_active]) &&
                    abs(old[0][most_active] - result[most_active]) > NOISE_QUANTITY {                  // recognize a negative slope threshold cross
                    if (interval >= MIN_INTERVAL) {                                 // ignore steps faster than one every 200ms
                        if(interval <= MAX_INTERVAL)  {                                     // ignore steps slower than one every 2s
                            steps++
                        }
                    }
                    interval = 0
            }
        }
    }
    
    func stopAccelerometer() {
        coreMotionManager.stopAccelerometerUpdates()
    }
}