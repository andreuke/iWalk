//
//  RecordsContentViewControllerFirstType.swift
//  iWalk
//
//  Created by Andrea Piscitello on 18/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import Charts

class RecordsContentViewControllerFirstType: RecordsContentViewController {
    
    struct Constants {
        static let Most = 0
        static let Average = 1
        
        static let titleStrings = ["Most steps in a day", "Average daily steps"]
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.mostStepsInADay.dayAndValueUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderData", name: Notifications.mostStepsInADay.hoursUpdated, object: nil)
        
        
        titleLabel.text = Constants.titleStrings[self.index]
        renderData()
    
        
    }
    
    // MARK: Deinitialization
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    func renderData() {
        switch index {
        case Constants.Most:
            if let day = self.recordsModel.mostStepsInADay.day {
                self.descriptionLabel.text = stringFromDate(day)
            }
            if let value = self.recordsModel.mostStepsInADay.value {
                self.valueLabel.text = String(value)
            }
            if let steps = self.recordsModel.mostStepsInADay.steps {
                let labels = self.recordsModel.mostStepsInADay.hours
                setChart(labels, values: steps)
            }
        case Constants.Average:
            self.descriptionLabel.text = ""
            if let value = self.recordsModel.averageDailySteps.value {
                self.valueLabel.text = String(value)
            }
        default:
            return
        }

    }
    
    func stringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    func setChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: Double(values[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
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
        barChartView.xAxis.setLabelsToSkip(10)
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.labelCount = 3
        

        barChartView.legend.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.gridBackgroundColor = UIColor.whiteColor()
        barChartView.drawGridBackgroundEnabled = false
        barChartView.setScaleEnabled(false)
        
        
        
    }
    
}
