//
//  RecordsViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 18/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController!
    
    @IBAction func swipeLeft(sender: AnyObject) {
        print("SWipe left")
    }
    
    @IBAction func swiped(sender: AnyObject) {
        
        self.pageViewController.view.removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        reset()
    }
    
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RecordsPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        var pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! RecordsContentViewController).index
        index++
        if(index >= RecordsContentViewController.numberOfDots){
            
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) ->UIViewController? {
        
        var index = (viewController as! RecordsContentViewController).index
        
        if(index <= 0){
            return nil
        }
        index--
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
       
        switch index {
        case 0,1:
            let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RecordsContentViewController") as! RecordsContentViewControllerFirstType
            pageContentViewController.index = index
            return pageContentViewController
        case 2:
            let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RecordsContentViewControllerSecondType") as! RecordsContentViewControllerSecondType
            pageContentViewController.index = index
            return pageContentViewController
        default:
            return nil
        }

    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return RecordsContentViewController.numberOfDots
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
    
}