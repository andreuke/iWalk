//
//  ContentViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 13/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
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
    @IBOutlet weak var barChart: JBBarChartView!
    
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
        
        showBarChart()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBarChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    var chartLegend = ["11-14", "11-15", "11-16", "11-17", "11-18", "11-19", "11-20"]
    var chartData = [70, 80, 76, 88, 90, 69, 74]
    
    func loadBarChart() {
//        barChart.backgroundColor = UIColor.whiteColor()
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = 100
        
//        barChart.reloadData()
        
        barChart.setState(.Collapsed, animated: false)
    }
    
    func showBarChart() {

        
//        var footerView = UIView(frame: CGRectMake(0, 0, barChart.frame.width, 16))
//        
//        print("viewDidLoad: \(barChart.frame.width)")
//        
//        var footer1 = UILabel(frame: CGRectMake(0, 0, barChart.frame.width/2 - 8, 16))
//        footer1.textColor = UIColor.whiteColor()
//        footer1.text = "\(chartLegend[0])"
//        
//        var footer2 = UILabel(frame: CGRectMake(barChart.frame.width/2 - 8, 0, barChart.frame.width/2 - 8, 16))
//        footer2.textColor = UIColor.whiteColor()
//        footer2.text = "\(chartLegend[chartLegend.count - 1])"
//        footer2.textAlignment = NSTextAlignment.Right
//        
//        footerView.addSubview(footer1)
//        footerView.addSubview(footer2)
//        
//        var header = UILabel(frame: CGRectMake(0, 0, barChart.frame.width, 50))
//        header.textColor = UIColor.whiteColor()
//        header.font = UIFont.systemFontOfSize(24)
//        header.text = "Weather: San Jose, CA"
//        header.textAlignment = NSTextAlignment.Center
//        
//        barChart.footerView = footerView
//        barChart.headerView = header
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // our code
        barChart.reloadData()
        showChart()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    func hideChart() {
        barChart.setState(.Collapsed, animated: false)
    }
    
    func showChart() {
        barChart.setState(.Expanded, animated: false)
    }
    
    // MARK: JBBarChartView
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return UIColor(hex: Colors.BlueColor)
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
        //        informationLabel.text = "Weather on \(key): \(data)"
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        //        informationLabel.text = ""
    }//
    
}
