//
//  PagesViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 13/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class PagesViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: Properties
    var pageController: UIPageViewController?
    var pageContent = NSArray()
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = UIPageViewController(
            transitionStyle: .Scroll,
            navigationOrientation: .Horizontal,
            options: nil)
        
        pageController?.delegate = self
        pageController?.dataSource = self
        
        let startingViewController: ContentViewController =
        viewControllerAtIndex(0)!
        
        let viewControllers: [UIViewController] = [startingViewController]
        pageController!.setViewControllers(viewControllers,
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: false,
            completion: nil)
        
        self.addChildViewController(pageController!)
        self.view.addSubview(self.pageController!.view)
        
        let pageViewRect = self.view.bounds
        pageController!.view.frame = pageViewRect
        pageController!.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: PageViewController Delegate Methods
    func viewControllerAtIndex(index: Int) -> ContentViewController? {
        let count = ContentViewController.Constants.AttributeStrings.count
        
        if (count == 0) ||
            (index >= count) {
                return nil
        }
        
        let storyBoard = UIStoryboard(name: "Main",
            bundle: NSBundle.mainBundle())
        let contentViewController = storyBoard.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        contentViewController.attribute = index
        return contentViewController
    }
    
    func indexOfViewController(viewController: ContentViewController) -> Int {
   
        if let attribute: Int = viewController.attribute {
            return attribute
        } else {
            return NSNotFound
        }
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController
            as! ContentViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController
            as! ContentViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == pageContent.count {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    
    
}
