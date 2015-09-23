//
//  TabBarController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 22/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var freshLaunch = true
    override func viewWillAppear(animated: Bool) {
        if freshLaunch == true {
            freshLaunch = false
            self.selectedIndex = 1
        }
        super.viewWillAppear(animated)
    }
}
