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
        let weightString = userInfo.attributeString(UserInfo.Attribute.Weight.rawValue)
        let weightStringNoKilo = weightString!.substringWithRange(Range<String.Index>(start: weightString!.startIndex, end: advance((weightString?.endIndex)!,-3)))
        self.weightLabel.text = weightStringNoKilo
    }
    
    
}