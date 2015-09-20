//
//  MeViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 04/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//
import UIKit
import Charts

class MeViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var barChartView: LineChartView!
    
    let userInfo = UserInfo.instance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthKitManager.instance.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
            }
            else
            {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateWeight", name: Notifications.weightUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateHeight", name: Notifications.heightUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBmi", name: Notifications.bmiUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateChart", name: Notifications.weightHistoryUpdated, object: nil)
        
        
        userInfo.fetchAllInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.renderData()
    }
    // MARK: Deinizialitaion
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeight() {
        if let weightString = userInfo.attributeString(UserInfo.Attribute.Weight.rawValue) {
        let weightStringNoKilo = weightString.substringWithRange(Range<String.Index>(start: weightString.startIndex, end: advance((weightString.endIndex),-3)))
        self.weightLabel.text = weightStringNoKilo
        }
    }
    
    func updateHeight() {
        if let heightString = userInfo.attributeString(UserInfo.Attribute.Height.rawValue) {
        let heightStringNoCm = heightString.substringWithRange(Range<String.Index>(start: heightString.startIndex, end: advance((heightString.endIndex),-3)))
        self.heightLabel.text = heightStringNoCm
        }

    }
    
    func updateBmi() {
        userInfo.calculateBmi()
        if let bmiString = userInfo.bmiString() {
            self.bmiLabel.text = bmiString
        }
    }
    
    func updateChart() {
        if let values = userInfo.weightHistoryValues {
            let labels = userInfo.weightHistoryDates
            
            setChart(labels!, values: values)
        }
    }
    
    func setChart(dataPoints: [NSDate], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
//
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        
        // Configuration
        chartDataSet.colors = [UIColor(hex:Colors.BlueColor)]
        chartDataSet.valueTextColor = UIColor.whiteColor()
        chartDataSet.drawValuesEnabled = false
        chartDataSet.highlightEnabled = false
        
        // Set rounding for values on bars
        let numberFormatter = NSNumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        chartDataSet.valueFormatter = numberFormatter
        
        
        barChartView.descriptionText = ""
        barChartView.xAxis.labelPosition = .Bottom
//        barChartView.xAxis.setLabelsToSkip(10)
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        
        barChartView.leftAxis.enabled = true
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.labelCount = 3
        
        
        barChartView.legend.enabled = false
        barChartView.gridBackgroundColor = UIColor.whiteColor()
        barChartView.drawGridBackgroundEnabled = false
        barChartView.setScaleEnabled(false)
        
        
        
    }
    
    func renderData() {
        self.updateHeight()
        self.updateWeight()
        self.updateBmi()
        self.updateChart()
    }

    
    
    
    
}