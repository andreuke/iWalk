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
        
        NSNotificationCenter.defaultCenter().addObserverForName(Notifications.totalRecords.stepsUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderData)
        NSNotificationCenter.defaultCenter().addObserverForName(Notifications.totalRecords.caloriesUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderData)
        NSNotificationCenter.defaultCenter().addObserverForName(Notifications.totalRecords.distanceUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderData)

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderData(notification: NSNotification) {
        renderData()
    }
    
    func renderData() {
        if let steps = recordsModel.totalLifetimeRecords.steps {
            stepsLabel.text = steps.addSpaceSeparator
        }
        if let calories = recordsModel.totalLifetimeRecords.calories {
            caloriesLabel.text = calories.addSpaceSeparator
        }
        if let distance = recordsModel.totalLifetimeRecords.distance {
            distanceLabel.text = distance.addSpaceSeparator
        }
    }
}
