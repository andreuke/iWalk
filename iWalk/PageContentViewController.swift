//
//  PageContentViewController.swift
//  iWalk
//
//  Created by Giada Tacconelli on 09/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    
    @IBOutlet weak var heading: UILabel!
    
    var pageIndex: Int?
    var titleText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heading.text = self.titleText
        
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
