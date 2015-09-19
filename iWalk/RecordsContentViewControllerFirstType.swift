//
//  RecordsContentViewControllerFirstType.swift
//  iWalk
//
//  Created by Andrea Piscitello on 18/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class RecordsContentViewControllerFirstType: RecordsContentViewController {

    struct Constants {
        static let Most = 0
        static let Average = 1
    
        static let titleStrings = ["Most steps in a day", "Average daily steps"]
    }
    
    @IBOutlet weak var title_text: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var description_text: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title_text.text = Constants.titleStrings[self.index]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
