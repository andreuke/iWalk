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
    
    let statsModel = StatsModel.instance
    
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
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    
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
        range = Constants.Year
        rangeString = Constants.RangeStrings[range!]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsModel.fetchAllData(range!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.stats.stepsUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.stats.caloriesUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.stats.distanceUpdated, object: nil)

        renderData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func renderData() {
        attributeLabel.text = attributeString
        rangeLabel.text = rangeString
        
        var values : [Double]?
        var labels : [String]?
        var average : Int?
        var total : Int?
        
        switch attribute! {
        case StatsModel.Attributes.Steps.rawValue:
            if let steps = statsModel.stepsData.steps {
                values = steps
                labels = statsModel.stepsData.labels
                average = statsModel.stepsData.average
                total = statsModel.stepsData.total
            }
            
        case StatsModel.Attributes.Calories.rawValue:
            if let calories = statsModel.caloriesData.calories {
                values = calories
                labels = statsModel.caloriesData.labels
                average = statsModel.caloriesData.average
                total = statsModel.caloriesData.total
            }
            
        case StatsModel.Attributes.Distance.rawValue:
            if let distance = statsModel.distanceData.distance {
                values = distance
                labels = statsModel.distanceData.labels
                average = statsModel.distanceData.average
                total = statsModel.distanceData.total
            }
        default:
            break
        }
        
        if let _ = average {
            averageLabel.text = String(average!)
        }
        
        if let _ = total {
            totalLabel.text = String(total!)
        }
        setChart(labels, values: values)
    }
    
    // MARK: BarChart
    func setChart(dataPoints: [String]?, values: [Double]?) {
        
        guard let _ = dataPoints else {
            return
        }
        
        guard let _ = values else {
            return
        }
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints!.count {
            let dataEntry = BarChartDataEntry(value: values![i], xIndex: i)
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
        barChartView.xAxis.setLabelsToSkip(10)
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        barChartView.leftAxis.enabled = true
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.valueFormatter = numberFormatter
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.labelCount = 5
        
        barChartView.legend.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.gridBackgroundColor = UIColor.whiteColor()
        barChartView.drawGridBackgroundEnabled = false
        barChartView.setScaleEnabled(false)
        
        
        
        
    }
    
}
