//
//  PageContentViewController.swift
//  iWalk
//
//  Created by Giada Tacconelli on 11/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {

    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var periodLabel: NSLayoutConstraint!
    @IBOutlet weak var barChart: JBBarChartView!
    @IBOutlet weak var label: UILabel!
    
    var pageIndex: Int?
    var titleText : String!
    
    var chartLegend = ["11-14", "11-15", "11-16", "11-17", "11-18", "11-19", "11-20"]
    var chartData = [70, 80, 76, 88, 90, 69, 74]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        heading.text = titleText
        
//        view.backgroundColor = UIColor.darkGrayColor()
        
        // bar chart setup
        barChart.backgroundColor = UIColor.darkGrayColor()
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = 100
        
        barChart.reloadData()
        
        barChart.setState(.Collapsed, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var footerView = UIView(frame: CGRectMake(0, 0, barChart.frame.width, 16))
        
        print("viewDidLoad: \(barChart.frame.width)")
        
        var footer1 = UILabel(frame: CGRectMake(0, 0, barChart.frame.width/2 - 8, 16))
        footer1.textColor = UIColor.whiteColor()
        footer1.text = "\(chartLegend[0])"
        
        var footer2 = UILabel(frame: CGRectMake(barChart.frame.width/2 - 8, 0, barChart.frame.width/2 - 8, 16))
        footer2.textColor = UIColor.whiteColor()
        footer2.text = "\(chartLegend[chartLegend.count - 1])"
        footer2.textAlignment = NSTextAlignment.Right
        
        footerView.addSubview(footer1)
        footerView.addSubview(footer2)
        
        var header = UILabel(frame: CGRectMake(0, 0, barChart.frame.width, 50))
        header.textColor = UIColor.whiteColor()
        header.font = UIFont.systemFontOfSize(24)
        header.text = "Weather: San Jose, CA"
        header.textAlignment = NSTextAlignment.Center
        
        barChart.footerView = footerView
        barChart.headerView = header
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // our code
        barChart.reloadData()
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    func hideChart() {
        barChart.setState(.Collapsed, animated: true)
    }
    
    func showChart() {
        barChart.setState(.Expanded, animated: true)
    }
    
    // MARK: JBBarChartView
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return (index % 2 == 0) ? UIColor.lightGrayColor() : UIColor.whiteColor()
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
//        informationLabel.text = "Weather on \(key): \(data)"
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
//        informationLabel.text = ""
    }//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
