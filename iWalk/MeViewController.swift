//
//  MeViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 04/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//
import UIKit

class MeViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    
    let userInfo = UserInfo.instance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthKitManager.instance.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
            }
            else
            {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateWeight", name: Notifications.weightUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateHeight", name: Notifications.heightUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBmi", name: Notifications.bmiUpdated, object: nil)
        
        userInfo.fetchAllInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateHeight()
        self.updateWeight()
        self.updateBmi()
    }
    // MARK: Deinizialitaion
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeight() {
        if let weightString = userInfo.attributeString(UserInfo.Attribute.Weight.rawValue) {
        let weightStringNoKilo = weightString.substringWithRange(Range<String.Index>(start: weightString.startIndex, end: advance((weightString.endIndex),-3)))
        self.weightLabel.text = weightStringNoKilo
        }
    }
    
    func updateHeight() {
        if let heightString = userInfo.attributeString(UserInfo.Attribute.Height.rawValue) {
        let heightStringNoCm = heightString.substringWithRange(Range<String.Index>(start: heightString.startIndex, end: advance((heightString.endIndex),-3)))
        self.heightLabel.text = heightStringNoCm
        }

    }
    
    func updateBmi() {
        userInfo.calculateBmi()
        if let bmiString = userInfo.bmiString() {
            self.bmiLabel.text = bmiString
        }
    }
    
    
}