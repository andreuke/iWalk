//
//  ContentViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 13/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import Charts

class PageContentViewController: UIViewController {
    
    // MARK: Static Attributes
    struct Constants {
        static let Steps = 0
        static let Calories = 1
        static let Distance = 2
        
        static let AttributeStrings = ["Steps", "Calories", "Distance"]
        
        static let Week = 0
        static let Month = 1
        static let Year = 2
        
        static let RangeStrings = ["week", "month", "year"]
    }
    
    
    // MARK: Properties
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!


    
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
        attribute = Constants.Steps
        attributeString = Constants.AttributeStrings[attribute!]
        range = Constants.Month
        rangeString = Constants.RangeStrings[range!]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let values = [20, 4.2, 6.2, 3.9, 12, 16, 4.7, 4.1, 3.9, 4, 5, 4]
        
        setChart(labels, values: values)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributeLabel.text = attributeString
        rangeLabel.text = rangeString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: BarChart
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        
        // Configuration
        chartDataSet.colors = [UIColor(hex:Colors.BlueColor)]
        chartDataSet.valueTextColor = UIColor.whiteColor()
        chartDataSet.drawValuesEnabled = true
        chartDataSet.highlightEnabled = false
        
        // Set rounding for values on bars
        let numberFormatter = NSNumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        chartDataSet.valueFormatter = numberFormatter

        
        barChartView.descriptionText = ""
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.legend.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.gridBackgroundColor = UIColor.whiteColor()
        barChartView.drawGridBackgroundEnabled = false
        barChartView.setScaleEnabled(false)
        
        

    }
    
}
