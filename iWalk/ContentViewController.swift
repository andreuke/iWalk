//
//  ContentViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 13/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    // MARK: Static Attributes
    struct Constants {
        static let Steps = 0
        static let Calories = 1
        static let Distance = 2
        
        static let AttributeStrings = ["Steps", "Calories", "Distance"]
        
        static let Week = 0
        static let Month = 1
        static let Year = 2
        
        static let RangeStrings = ["Week", "Month", "Year"]
    }
    
    
    // MARK: Properties
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    var attribute : Int? {
        didSet {
            attributeString = Constants.AttributeStrings[attribute!]
        }

    }
    var attributeString : String?
    
    var range : Int? {
        didSet {
            rangeString = Constants.RangeStrings[range!]
        }
        
    }
    var rangeString : String?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        range = Constants.Month
        rangeString = Constants.RangeStrings[range!]
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        attributeLabel.text = attributeString
        rangeLabel.text = rangeString
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
