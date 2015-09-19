//
//  RecordsContentViewControllerSecondType.swift
//  iWalk
//
//  Created by Andrea Piscitello on 18/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class RecordsContentViewControllerSecondType: RecordsContentViewController {


    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.totalRecords.stepsUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.totalRecords.caloriesUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.totalRecords.distanceUpdated, object: nil)

        // Do any additional setup after loading the view.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderData() {
        if let steps = recordsModel.totalLifetimeRecords.steps {
            stepsLabel.text = String(steps)
        }
        if let calories = recordsModel.totalLifetimeRecords.calories {
            caloriesLabel.text = String(calories)
        }
        if let distance = recordsModel.totalLifetimeRecords.distance {
            distanceLabel.text = String(distance)
        }
    }
}
